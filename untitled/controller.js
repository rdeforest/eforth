    var FormModel = Backbone.Model.extend({
      initialize: function(){
        this.set('entity', new Entity({formChoice: this.get('formChoice')}));
        if(this.isClassicForm()){
          this.set('junkyard', new JunkyardModel);
        }
      },
      setup: function(){
        var hostclass;
        var serverType = this.getLineComponentModel('server-family', 0);
        var cluster = this.getLineComponentModel('cluster', 0);
        var fabric = this.getLineComponentModel('fabric', 0);
        var az = this.getLineComponentModel('az', 0);
        var entity = this.getEntity();
        var tweakByAZ = this.getLineComponentModel('redundancy', 3);
        var reasonType = this.getLineComponentModel('reason-type', 0);
        var azGenerator = new AZGenerator;
        var deliveryDateView = new DeliveryDateView({el: $(".delivery-date")});
        this.set('deliveryDateView', deliveryDateView);
        if(this.isAWSForm()){
          deliveryDateView.model.set("requestType", "VPC EC2");
          var fleet = this.getLineComponentModel('fleet', 0);
          var env = this.getLineComponentModel('environment', 0);
          var genre = this.getLineComponentModel('genre', 0);
          var stage = this.getLineComponentModel('environment', 1);
          var showOptional = this.getLineComponentModel('server-family', 1);
          this.capacity = new EnvironmentStageCapacities;
          this.listenTo(fleet, 'change', this.fetchEntity);
          this.listenTo(env, 'change', this.fetchEntity);
          this.listenTo(genre, 'change', this.swapSelector);
          this.listenTo(stage, 'change', this.stageChange);
          this.listenTo(stage, 'change', this.fetchCapacity);
          this.listenTo(showOptional, 'change', this.updateServerTypes);
          //this function answer the calls to modify filter conditions
          this.listenTo(this, 'filterChange', this.filterChange);
          azGenerator.populateDictionary(awsAZPriority);
        }else if(this.isClassicForm()){
          deliveryDateView.model.set("requestType", "Legacy");
          hostclass = this.getLineComponentModel('hostclass', 0);
          this.listenTo(hostclass, 'change', this.fetchEntity);
          var MAWSSurvey = this.getLineComponentModel('maws-choice', 0);
          var junkyard = this.get('junkyard');
          this.listenTo(MAWSSurvey, 'change', this.showMAWSDetail);
          this.listenTo(junkyard, 'recycled_hardware_checked', this.recycled_hardware_checked);
          azGenerator.populateDictionary(classicAZPriority);
        }
        this.set('azGenerator', azGenerator);
        this.setupRedundancy();
        this.listenTo(fabric, 'change', this.fabricChange);
        this.listenTo(entity, 'fetched', this.entityFetched);
        this.listenTo(cluster, 'selectedChange', this.updateServerTypes);
        this.listenTo(serverType, 'selectedChange', this.buildAZ);
        this.listenTo(entity, 'fetchError', this.entityError);
        this.listenTo(az, 'change', this.azChange);
        this.listenTo(this, 'costChange', this.costChange);
        this.listenTo(entity, 'submissionSucess', this.showCheckoutView);
        this.listenTo(entity, 'checkoutSuccess', this.redirect);
        this.listenTo(entity, 'findNearestFleet', this.findNearestFleet);
        this.listenTo(entity, 'osDsmSucess', this.setupOsDsmOptions);
        this.listenTo(tweakByAZ, 'callForTweak', this.answerForTweak);
        this.listenTo(reasonType, 'change', this.updateReasons);
        this.listenTo(this, '3rdAZSelected', this.ceilingAfterThird);
        this.listenTo(this, 'lessThan3Selected', this.unceilingBeforeThird);
        //fleet selector passiveDeath event setup
        var selectors = this.get('fleetSelectors').models;
        var length = selectors.length;
        for(var i = 0; i < length-1; i++){
          for(var j = i+1; j < length; j++){
            var selectorA = selectors[i];
            var selectorB = selectors[j];
            selectorA.listenTo(selectorB, 'live', selectorA.passiveDeath);
            selectorB.listenTo(selectorA, 'live', selectorB.passiveDeath);
          }
        }

        //fleetselectorwrapper now can access the value of the input
        for(var i = 0; i < length; i++){
          this.setFleetSelecotrInputModel(selectors[i].getID());
        }

        //set up active origin line of entity fetching
        if(this.isClassicForm()){
          this.set('activeEntityOrginLine', 'hostclass');
        }else{
          this.set('activeEntityOrginLine', this.getAWSGenre());
        }
        //mapping button setup
        var mappingButton = this.getFleetSelectorModel('mapping-selector').getView().$el.parent().find('button#mapping');
        mappingButton.click($.proxy(this.mapToFleet, this));
        //submit button setup
        var submitButton = $('#submit');
        submitButton.click($.proxy(this.placeOrder,this));
        this.disableForCorrectFetch();
      },
      fetchCapacity: function(){
        var environment = this.getLineComponentModel('environment', 0).getValue();
        var stage = this.getLineComponentModel('environment', 1).getValue();
        if(environment && stage)
          this.capacity.fetch({data: {environment: environment, stage: stage}});
      },
      recycled_hardware_checked: function(params, hardwares){
        var serverTypeSupportiveView = this.getLineView('server-family').model.get('supportiveView');
        if (_.keys(hardwares).length > 0){
          serverTypeSupportiveView.loadContent(
            junkyard_message_by_cluster(params.fabric, params.cluster)
          );
          serverTypeSupportiveView.safeShow();
        }
        else{
          serverTypeSupportiveView.safeHide();
        }
      },
      updateReasons: function(){
        var reasons = this.getLineComponentModel('reason', 0);
        var reasonType = this.getLineComponentModel('reason-type', 0).getValue();
        var reasonObjects = _.map(reasonHash[reasonType], function(reason){
          return {name: reason, value: reason};
        });
        reasons.updateList(reasonObjects);
      },
      fetchTags: function(){
        var type = this.getActiveEntityOrginLineID();
        var name = this.getLineComponentModel(type, 0).getValue();
        var fabric = this.getLineComponentModel('fabric', 0).getValue();
        var serverType = this.getLineComponentModel('server-family', 0).getValue();
        var cluster = this.getLineComponentModel('cluster', 0).getValue();
        var params = {type: type, name: name, fabric: fabric}
        if(serverType)
          params = _.extend(params, {server_type: serverType});
        if(cluster)
          params = _.extend(params, {cluster: cluster});
        this.getEntity().fetchTags({data: params});
      },
      updateTags: function(list){
        var tagView = this.getLineComponentView('tag',0);
        tagView.renderChosenSelect(list);
      },
      filterChange: function(newCondition){
        var totalConditions = this.get('totalConditions');
        if(!totalConditions)
          totalConditions = {};
        totalConditions = _.extend(totalConditions, newCondition);
        var keys = _.keys(totalConditions);
        _.each(keys, function(key){
          if(!totalConditions[key])
            delete totalConditions[key];
        });
        if(this.getAWSGenre()!='environment'){
          delete totalConditions['stage'];
        }
        this.set('totalConditions',totalConditions);
        this.get('inventoryTable').filterTableWith(totalConditions);
      },
      wipeOutFilter: function(){
        this.set('totalConditions', {});
        this.filterChange({});
      },
      stageChange: function(){
        stage = this.getLineComponentModel('environment', 1).getValue();
        this.trigger('filterChange', {stage: stage});
      },
      showMAWSDetail: function(){
        var mawsChoice = this.getLineComponentView('maws-choice', 0);
        var $detailLine = this.getLineView('maws-detail').$el;
        if(mawsChoice.needDetail()){
          $detailLine.show('blind');
        }else if($detailLine.css('display')!='none'){
          $detailLine.hide('blind');
        }
      },
      answerForTweak: function(){
        //look for existing tweak from
        var azModel = this.getLineComponentModel('az', 0);
        var qtyPerAZ = this.getLineComponentModel('redundancy', 0);
        if(azModel.getValue()){
          //if az has been initialized, then we can tweak by az
          var tweakFormView = this.get('tweakFormView');
          if(!tweakFormView){
            tweakFormView = new TweakFormView({el: $('.tweak-form'), azModel: azModel, qtyModel: qtyPerAZ});
            this.listenTo(tweakFormView.model, 'callForEvenForm', this.answerForEvenFrom);
            this.listenTo(tweakFormView.model, 'costChange', this.costChange);
          }
          this.set('tweakFormView', tweakFormView);
          tweakFormView.show();
          //this need refactor
          $('.simple-form').hide();

          this.trigger('costChange');
        }
      },
      answerForEvenFrom: function(){
        var tweakFormView = this.get('tweakFormView');
        if(tweakFormView){
          $('.simple-form').show();
          tweakFormView.hide();
          this.trigger('costChange');
        }else{
          throw 'tweakFormView should not be undefined';
        }
      },
      setupOsDsmOptions: function(osDsmData){
        var osChoice = osDsmData.os_choice;
        var dsmChoice = osDsmData.dsm_choice;
        var osChoiceArray = simpleListToHashArray(osChoice);
        var dsmChoiceArray = tupleToHashArray(dsmChoice);
        var os = this.getLineComponentModel('os-dsm', 0);
        var dsm = this.getLineComponentModel('os-dsm', 1);
        os.updateList(osChoiceArray, true);
        dsm.updateList(dsmChoiceArray, true);
        function simpleListToHashArray(list){
          return _.map(list, function(el){
            return {name: el, value: el};
          });
        }
        function tupleToHashArray(tuples){
          return _.map(tuples, function(tuple){
            return {name: tuple[0], value: tuple[1]};
          });
        }
      },
      showCheckoutView: function(summary){
        //stop loding bar and remove it
        stop_progress();
        $('#progress_container').remove();

        var errors;
        if(errors=summary.errors){
          this.trigger('showFormError', {errors: errors})
        }else{
          this.trigger('showFormError');
          var modal = this.get('modalView');
          if(!modal){
            this.set('modalView', modal = new CheckoutModalView({el: $('.checkout-modal')}));
            this.listenTo(modal.model, 'checkout', this.checkout);
          }
          modal.showModal(summary);
        }
      },
      redirect: function(checkoutJSON){
        if(!checkoutJSON.errors){

          //redirect to view my requests
          var request_type = checkoutJSON.request_type
          window.location.href = "/requests?tab="+request_type+"&default=TRUE";
        }else{
          var modalView = this.get('modalView');
          modalView.showError(checkoutJSON);
        }
      },
      costChange: function(toGenerateReport){
        var totalQuantity;
        var azQtyHash = {};
        var serverType = this.getLineComponentModel('server-family',0).getValue();
        var tweakFormView = this.get('tweakFormView');
        if(tweakFormView && tweakFormView.isVisible()){
          totalQuantity = tweakFormView.getTotal();
          azQtyHash = tweakFormView.getSnapShot();
        }else{
          var AZs = this.getLineComponentModel('az', 0).getValue();
          var qty = this.getLineComponentModel('redundancy', 0).getValue();
          _.each(AZs, function(az){
            azQtyHash[az] = qty;
          });
          totalQuantity = this.getLineComponentModel('redundancy', 2).getValue();
        }
        var serverType;
        if(this.isClassicForm()){
          serverType = this.getLineComponentView('server-family', 0).getText();
        }else{
          serverType = this.getLineComponentModel('server-family', 0).getValue();
        }
        var cluster = this.getLineComponentView('cluster', 0).getText();
        var capex = this.get('specTable').model.getCapexValue(serverType, cluster);
        var usage = this.get('specTable').model.getUsageValue(serverType, cluster);
        var totalCapex = capex*totalQuantity;
        var totalUsage = usage*totalQuantity;

        var redundancyLine = this.getLineView('redundancy');
        var supportiveView = redundancyLine.model.get('supportiveView');
        log('Cost changed! capex: $'+ (capex*totalQuantity) + ', usage: $' + (usage*totalQuantity));
        if( capex != 0 || usage != 0 ){
          var message = totalQuantity + ' ' +
            (this.isAWSForm() ? 'Instance' : 'server') +
            (totalQuantity > 1 ? 's' : '') + ' ' +
            'will cost you' +
            ' '+ formatCurrency(totalUsage.toFixed(2)) + ' for monthly usage.';
          log(message);
          supportiveView.loadContent(message).safeShow();
        }else{
          supportiveView.safeHide();
        }
        var costChangeReport = {
          serverType: serverType,
          azQtyHash: azQtyHash
        };
        var deliveryParams = {
          fabric: this.getLineComponentModel('fabric', 0).getValue(),
          serverType: this.getLineComponentModel('server-family', 0).getValue(),
          azQtyHash: azQtyHash
        }
        var deliveryDateView = this.get('deliveryDateView');
        deliveryDateView.model.updateCostChangeReport(deliveryParams);
        this.set('costChangeReport', costChangeReport);
        if(toGenerateReport)
          this.trigger('costChangeReport', costChangeReport);
      },
      mapToFleet: function(){
        var mappingSelectorValue = this.getFleetSelectorModel('mapping-selector').getValue();
        var entity = this.getEntity();
        var options = {};
        var facts = this.collectFacts();
        var map_type = facts.type;
        if(map_type =='environment'){
          map_type = 'apollo_environment';
        }
        var mapHash = {};
        mapHash[map_type] = [facts.name];
        options.data = _.extend(facts, {map: mapHash, fleet: mappingSelectorValue});
        this.getLoaderDependent().resetLoader().setLoader();
        entity.map(options);
      },
      swapSelector: function(){
        var genre = this.getLineComponentModel('genre', 0);
        var selectors = ['fleet', 'environment'];
        var selectedID = genre.getValue();
        var unselectedID = selectors[1-selectors.indexOf(selectedID)];
        var selectedSelector = this.get('lines').findWhere({id: selectedID});
        var unselectedSelector = this.get('lines').findWhere({id: unselectedID});
        unselectedSelector.getView().$el.hide('blind', {complete: function(){
          selectedSelector.getView().$el.show('blind');
        }});

        //update the activeLineID
        this.set('activeEntityOrginLine', this.getAWSGenre());
        this.fetchEntity();
        this.wipeOutFilter();
        genre.unlock();
      },
      fabricChange: function(){
        var activeLineModel = this.getLineComponentModel(this.getActiveEntityOrginLineID(), 0);
        if(activeLineModel.getValue()){
          this.fetchEntity();
        }
      },
      setupRedundancy: function(){
        var redundancies = this.get('lines').findWhere({id: 'redundancy'}).get('inputs');
        var total = redundancies[2].model;
        var qtyPerAZ = redundancies[0].model;
        var AZnumber = redundancies[1].model;
        this.listenTo(AZnumber, 'change', this.azNumberChange);
        this.listenTo(AZnumber, 'changeFromBrowser', this.activeAZNumberChange);
        this.listenTo(qtyPerAZ, 'change', this.qtyChange);
      },
      qtyChange: function(){
        var redundancies = this.get('lines').findWhere({id: 'redundancy'}).get('inputs');
        var total = redundancies[2];
        var qtyPerAZ = redundancies[0].model;
        var AZ = redundancies[1].model;
        total.updateValue(qtyPerAZ.getValue() * AZ.getValue());
        this.trigger('costChange');
      },
      azNumberChange: function(){
        this.qtyChange();
      },
      activeAZNumberChange: function(options){
        if(!options){
          options = {}
        }
        var cluster = this.getLineComponentModel('cluster', 0).getValue();
        var serverType = this.getLineComponentModel('server-family', 0).getValue();
        if(cluster && serverType){
          var azSelection = this.getEntity().filteredList()[serverType][cluster];
          var redundanciesAZ = this.getLineComponentModel('redundancy', 1).getValue();
          var generatedSelection = [];
          var azView = this.getLineComponentView('az', 0);
          var azModelValue = this.getLineComponentModel('az', 0).getValue();
          if(this.capacity || this.getEntity().get('hostclass_capacities')){
            var existingAZs = [];
            if(this.capacity){
              existingAZs = _.map(this.capacity.where({ec2_instance_type: serverType}), function(cap){
                return cap.get('availability_zone');
              });
            }else{
              existingAZs = _.map(_.filter(this.getEntity().get('hostclass_capacities'), function(cap){
                return cap.server_type == serverType;
              }), function(cap){
                return cap.datacenter;
              });
            }

            existingAZs = _.intersection(azSelection, existingAZs)
            if(existingAZs.length > 0){
              var existingTaking = Math.min(existingAZs.length, redundanciesAZ);
              generatedSelection = generatedSelection.concat(this.get('azGenerator').generate(existingTaking, existingAZs));
              redundanciesAZ = redundanciesAZ - existingTaking;
              azSelection = _.difference(azSelection, generatedSelection);
            }
          }
          if(!options.default || generatedSelection.length == 0){
            // if this is not a default setting or we don't get any available existing AZs.
            generatedSelection = generatedSelection.concat(this.get('azGenerator').generate(redundanciesAZ, azSelection));
          }
          azView.enableOtherOptions();
          azView.selectInChosenOptions(generatedSelection);
        }
      },
      azChange: function(){
        var azView = this.getLineComponentView('az', 0);
        var az = azView.model;
        var cluster = this.getLineComponentModel('cluster', 0).getValue();
        var serverType = this.getLineComponentModel('server-family', 0).getValue();
        if(cluster && serverType){
          var redundanciesAZ = this.getLineComponentView('redundancy', 1);
          var azLength = this.getEntity().filteredList()[serverType][cluster].length;
          //az could be undefined
          var length = az.getValue() ? az.getValue().length : 0 ;
          redundanciesAZ.updateValue(length);
          var maxClusterSize = this.maxClusterSize();
          if(length < maxClusterSize){
            this.trigger('lessThan3Selected');
            if(length == 1){
              azView.hideClose();
            }else{
              azView.showClose();
            }
          }else if(length >= maxClusterSize && azLength > maxClusterSize){
            this.trigger('3rdAZSelected');
          }
          if(this.isAWSForm() && length > 0)
            this.trigger('filterChange', {az: az.getValue()});
        }
      },
      ceilingAfterThird: function(){
        var azView =  this.getLineComponentView('az', 0);
        azView.disableOtherOptions();
        var azLine = this.getLineView('az');
        azLine.renderSupportiveView();
        var supportiveView = azLine.model.get('supportiveView');
        var maxClusterSize = this.maxClusterSize();
        supportiveView.loadContent('You may select at most ' + maxClusterSize + ' availability zones.  Remove a selected availability zone if you wish to choose a different one.').safeShow();
      },
      unceilingBeforeThird: function(){
        var azView =  this.getLineComponentView('az', 0);
        azView.enableOtherOptions();
        var azLine = this.getLineView('az');
        var supportiveView = azLine.model.get('supportiveView');
        if(supportiveView){
          supportiveView.safeHide();
        }
      },
      buildAZ: function(){
        var cluster = this.getLineComponentModel('cluster', 0).getValue();
        var serverType = this.getLineComponentModel('server-family', 0).getValue();
        var AZs;
        if(!serverType)
          AZs = [];
        else
          AZs = this.getEntity().filteredList()[serverType][cluster];
        var serverView = this.getLineComponentView('server-family', 0);
        var azView =  this.getLineComponentView('az', 0);
        var redundancies = this.get('lines').findWhere({id: 'redundancy'}).get('inputs');
        var AZ = redundancies[1].model;
        var specification = this.get('specTable');
        var maxClusterSize = this.maxClusterSize();
        AZ.setRange(0, Math.min(AZs.length, maxClusterSize));
        azView.renderChosenSelect(AZs,true);
        azView.restrictOptionSize(maxClusterSize);
        this.azChange();
        this.activeAZNumberChange({default: true});

        // scroll the spec table to the row being selected
        try{
          if(!serverType)
            return;
          if(this.isClassicForm())
            scrollToBy = 'Server Type';
          else
            scrollToBy = 'Instance Type';
          specification.scrollTo(scrollToBy, serverView.getText());
        }catch(e){
          log('ScrollTo failed');
        }

        //if classic form, check if need to update maws select
        if(this.isClassicForm()){
          var choiceType;
          if(dbTypes.indexOf(serverType)!=-1){
            choiceType = 'db';
          }else{
            choiceType = 'non-db';
          }
          var mawsChoice = this.getLineComponentModel('maws-choice', 0);
          var currentType = mawsChoice.getChoiceType();
          if(currentType!=choiceType){
            mawsChoice.updateList( choiceType == 'db' ? dbChoices : nonDbChoices);
          }
        }

        //fetch os/dsm for legacy form
        if(this.isClassicForm()){
          var osDsmOptions = {};
          var serverType = this.getLineComponentModel('server-family', 0).getValue();
          osDsmOptions.data = {server_type: serverType};
          this.getEntity().osDsm(osDsmOptions);
        }
        this.trigger('costChange');
        //trigger filter change
        if(this.isAWSForm())
          this.trigger('filterChange', {serverType: serverType});
      },
      maxClusterSize: function(){
        var cluster = this.getLineComponentModel('cluster', 0).getValue();
        var maxClusterSize = 3;
        if(ec2_redundancy_thresholds[cluster]){
          maxClusterSize = ec2_redundancy_thresholds[cluster]
        }
        return maxClusterSize;
      },
      clusterChangeMRC: function(cluster){
        var specification = this.get('specTable');
        specification.updateCapexNMrc(cluster);
      },
      collectFacts: function(){
        if(this.isClassicForm()){
          var hostclassLine = this.get('lines').findWhere({id: 'hostclass'});
          var hostclass = hostclassLine.get('inputs')[0];
          var fabric = this.getLineComponentModel('fabric', 0);
          return {type: 'hostclass', name: hostclass.model.getValue(), fabric: fabric.getValue()};
        }else if(this.isAWSForm()){
          var genre = this.getLineComponentModel('genre', 0).getValue();
          var entity = this.getModelByGenre(genre);
          var fabric = this.getLineComponentModel('fabric', 0);
          return {
            type: genre,
            name: entity.getValue(),
            fabric: fabric.getValue()
          };
        }else{
          throw 'wrong form type: '+this.get('formChoice');
        }
      },
      fetchEntity: function(){
        this.get('specTable').safeClose();
        var facts = this.collectFacts();
        var entity = this.getEntity();
        var needToFetch = true;
        //last fetch param
        var lastOption = entity.get('ajaxOptions');
        if(lastOption){
          if(_.isEqual(facts, lastOption.data)){
            needToFetch = false;
          }
        }
        if(facts.name && facts.name.trim().length > 0 && needToFetch){
          if(this.isClassicForm()){
            this.get('inventoryTable').safeClose();
            var hostclassLine = this.get('lines').findWhere({id: 'hostclass'});
            var hostclass = hostclassLine.get('inputs')[0];
            hostclass.resetLoader().setLoader();
            var options={};
            options.data = facts;
            this.get('entity').fetch(options);
          }else if(this.isAWSForm()){
            //load ec2 table with finest granularity. Use the filter input to narrow down when st and az is chosen
            //this loading strategy could take some time, so making a secondary call for inventory table alone for ec2
            var genre = this.getLineComponentModel('genre', 0).getValue();
            var loaderDependent = this.getLoaderDependentByGenre(genre);
            loaderDependent.resetLoader().setLoader();
            var options = {};
            options.data = facts;
            this.get('entity').fetch(options);
          }else{
            throw 'wrong form type: '+this.get('formChoice');
          }
          //lock UI for safe display
          this.disableDuringFetch();
          this.trigger('startFetch');
        }
      },
      entityFetched: function(){
        //enable stuff if any is disabled
        this.enableForFetchSuccess();

        //set success icon
        this.getLoaderDependent().resetLoader().setSuccess();

        var lineView = this.getLineView(this.getActiveEntityOrginLineID());
        var banner = lineView.model.getOrCreateInfoBanner();
        banner.removeBanner();

        var callback = $.proxy(function(){
          //show mapping info
          if(this.getAWSGenre()!='fleet'){
            var mappingMessage = this.get('entity').templateMappingMessage();
            var activeLineView = this.getLineView(this.getActiveEntityOrginLineID());
            activeLineView.model.getOrCreateInfoBanner().createBanner(mappingMessage, 'positive').appendBannerIn(activeLineView.$el).showBanner();
          }
        },this);

        //get rid of validation msg/mapping info, if any
        var supportiveView = lineView.model.get('supportiveView');
        if(supportiveView){
          supportiveView.safeHide(callback);
        }

        //setup tables
        var specification = this.get('specTable');
        var specificationData = this.get('entity').serverSpecification();
        var servers = this.get('entity').serverTypeList();
        var serverTypes = _.pluck(servers, 'value');
        specification.renderSpecificationTable(this.get('formChoice'), specificationData, serverTypes);
        specification.safeOpen();

        var inventory = this.get('inventoryTable');
        var inventoryTable = this.get('entity').inventoryTable();
        if(this.isClassicForm()){
          inventory.renderSelfExplanedTable(inventoryTable);
        }else{
          //assemble ec2_inventory url
          var ec2_inventory_route = this.getEntity().get('ec2_inventory_route');
          inventory.renderEc2InventoryTable(inventoryTable, this.getAWSGenre(), ec2_inventory_route);
        }
        inventory.safeOpen();
        var cluster = this.getLineComponentModel('cluster', 0);
        var clusters = this.getEntity().invertedClusterList();
        cluster.updateList(clusters);

        var emailCCList = this.getLineComponentView('email-cc-list', 0);
        var emailList = this.get('entity').emailCCList();
        emailCCList.renderChosenSelect(emailList, false);

        //following would trigger filterchange event, so it needs to be put after table loading
        if(this.getAWSGenre() == 'environment'){
          this.updateStages();
        }
        //unlock UI
        this.enableAfterFetch();

        this.trigger('entityFetched');
        //unlock from swticher
        this.trigger('unlockFormSwithcer');
      },
      updateServerTypes: function(){
        var cluster = this.getLineComponentModel('cluster', 0).getValue();
        var showOptionalTypes;

        if(this.isClassicForm()){
            var fabric = this.getLineComponentModel('fabric', 0).getValue();
            // this.get('junkyard').check_recycled_hardware(fabric, cluster);
        }

        //trigger filter conditions on ec2 inventory table to change
        if(this.isAWSForm()){
          this.trigger('filterChange', {cluster: cluster});
          showOptionalTypes = this.getLineComponentModel('server-family', 1).getValue();
        }
        //update the server spec table with the cluster chosen
        var serverTypeList;
        var serverType = this.getLineComponentModel('server-family', 0);
        if(cluster){
          this.clusterChangeMRC(cluster);
          serverTypeList = this.getEntity().serverTypeArray(cluster, this.isAWSForm(), showOptionalTypes);
        }else{
          //clear server type list
          serverTypeList = [];
        }

        serverType.updateList(serverTypeList);
      },
      updateStages: function(){
        var stage = this.getLineComponentModel('environment', 1);
        stage.updateList(this.get('entity').get('stageList'), true);
      },
      updateCluster: function(){
        var cluster = this.get('lines').findWhere({id: 'cluster'}).get('inputs')[0].model;
        var serverView = this.get('lines').findWhere({id: 'server-family'}).get('inputs')[0];
        var serverFamily = serverView.model;
        var clusters = this.get('entity').clusterList(serverFamily.getValue());
        var specification = this.get('specTable');
        cluster.updateList(clusters);
        if(this.isClassicForm())
          scrollToBy = 'Server Type';
        else
          scrollToBy = 'Instance Type';
        specification.scrollTo(scrollToBy, serverView.getText());

        //if classic form, check if need to update maws select
        if(this.isClassicForm()){
          var serverType = serverFamily.getValue();
          var choiceType;
          if(dbTypes.indexOf(serverType)!=-1){
            choiceType = 'db';
          }else{
            choiceType = 'non-db';
          }
          var mawsChoice = this.getLineComponentModel('maws-choice', 0);
          var currentType = mawsChoice.getChoiceType();
          if(currentType!=choiceType){
            mawsChoice.updateList( choiceType == 'db' ? dbChoices : nonDbChoices);
          }
        }
      },
      findNearestFleet: function(data){
        var mappingSelector = this.getFleetSelectorModel('mapping-selector');
        mappingSelector.setValue(data.fleet_name);
      },
      entityError: function(error){
        this.disableForCorrectFetch();

        var lineView = this.getLineView(this.getActiveEntityOrginLineID());
        var loaderDependent = this.getLoaderDependent();
        loaderDependent.resetLoader().setWrong();
        var bannerView = lineView.model.getOrCreateInfoBanner();
        var supportiveView = lineView.model.get('supportiveView');
        var messageHTML = this.get('entity').getErrorMessage();
        var hider, shower, hideFun;

        if(supportiveView && supportiveView.isOpen()){
          hider = supportiveView;
          hideFun = supportiveView.safeHide;
        }else{
          hider = bannerView;
          hideFun = bannerView.hideBanner;
        }

        var model = this;
        var openFun = function(){
          if(error != 'UNMAPPED_ERROR'){
            bannerView.createBanner(messageHTML, 'negative').appendBannerIn(lineView.$el).showBanner();
          }else{
            //mapping view
            model.getEntity().findNearestFleet(model.getEntity().get('ajaxOptions'));
            lineView.model.get('supportiveView').safeShow();
          }
        }

        hideFun.apply(hider, [openFun]);
        //unlock UI after fetch
        this.enableAfterFetch();
        this.trigger('unlockFormSwithcer');
      }
    }).extend({
        //utilities
        getEntity: function(){
          return this.get('entity');
        },
        getActiveEntityOrginLineID: function(){
          return this.get('activeEntityOrginLine');
        },
        getLineView: function(lineID){
          return this.get('lines').findWhere({id: lineID}).getView();
        },
        getLineComponentView: function(lineID, inputIndex){
          return this.get('lines').findWhere({id: lineID}).get('inputs')[inputIndex];
        },
        getLineComponentModel: function(lineID, inputIndex){
          return this.getLineComponentView(lineID, inputIndex).model;
        },
        getFleetSelectorModel: function(selectorID){
          return this.get('fleetSelectors').findWhere({id: selectorID});
        },
        getLoaderDependentByGenre: function(genre){
          if(genre == 'fleet')
            return this.getFleetSelectorModel('fleet-selector').getView();
          else if (genre == 'environment')
            return this.getLineComponentView('environment', 1);
          else
            throw 'Wrong genre type: '+genre;
        },
        getModelByGenre: function(genre){
          if(genre == 'fleet')
            return this.getFleetSelectorModel('fleet-selector');
          else if (genre == 'environment')
            return this.getLineComponentModel('environment', 0);
          else
            throw 'Wrong genre type: '+genre;
        },
        getLoaderDependent: function(){
          var activeLine = this.getActiveEntityOrginLineID();
          if(activeLine == 'fleet')
            return this.getFleetSelectorModel('fleet-selector').getView();
          else if(activeLine == 'environment')
            return this.getLineComponentView(activeLine, 1);
          else
            return this.getLineComponentView(activeLine, 0);
        },
        getAWSGenre: function(){
          if(this.isAWSForm()){
            return this.getLineComponentModel('genre', 0).getValue();
          }
        },
        setFleetSelecotrInputModel: function(selectorID){
          var inputView;
          var fleetSelector = this.getFleetSelectorModel(selectorID);
          if(selectorID == 'fleet-selector')
            inputView = this.getLineComponentView('fleet', 0);
          else if (selectorID == 'mapping-selector'){
            var lineID, index;
            if(this.isAWSForm()){
              lineID = 'environment';
              index = 2;
            }
            else{
              lineID = 'hostclass';
              index = 1;
            }
            inputView = this.getLineComponentView(lineID, index);
          }
          fleetSelector.setInputView(inputView);
        },
        isAWSForm: function(){
          return "AWS" == this.get('formChoice');
        },
        isClassicForm: function(){
          return "Classic" == this.get('formChoice');
        },
        getInputViewsToDisable: function(){
          var views = this.get('viewsToDisable');
          if(views == undefined){
            var lineIDs = this.get('lines').pluck('id');
            var beginLineIndex = lineIDs.indexOf('cluster');
            var linesToDisable = lineIDs.slice(beginLineIndex);
            var model = this;
            views = [];
            _.map(linesToDisable, function(ID){
              var inputViews = model.getLineView(ID).model.get('inputs');
              _.each(inputViews, function(view){
                views.push(view);
              });
            });
            this.set('viewsToDisable',views);
          }
          return views;
        },
        //these are used to block user from going forward when ordering unit is false
        disableForCorrectFetch: function(){
          var inputViews = this.getInputViewsToDisable();
          _.each(inputViews, function(view){
            view.$el.attr('disabled', true);
          });
          $('#submit').attr('disabled', true);
        },
        enableForFetchSuccess: function(){
          var inputViews = this.getInputViewsToDisable();
          _.each(inputViews, function(view){
            view.$el.removeAttr('disabled');
          });
          $('#submit').removeAttr('disabled');
        },
        //these are used to prevent UI crash
        disableDuringFetch: function(){
          var linesToDisable = ['fabric'];
          if(this.isAWSForm()){
            linesToDisable.push('genre');
          }
          var model = this;
          _.each(linesToDisable, function(line){
            var view = model.getLineComponentView(line, 0);
            view.$el.attr('disabled', true);
          })
        },
        enableAfterFetch: function(){
          var linesToDisable = ['fabric'];
          if(this.isAWSForm()){
            linesToDisable.push('genre');
          }
          var model = this;
          _.each(linesToDisable, function(line){
            var view = model.getLineComponentView(line, 0);
            view.$el.removeAttr('disabled');
          })
        }
      }).extend({
        //form submission
        getFormHashForSubmission: function(){
          var submissionHash = {};
          var lineIDs = this.get('lines').pluck('id');
          var model = this;
          _.each(lineIDs, function(line){
            gatherInfoByLine(line);
          });
          var errors = [];
          try{
            submissionHash['az_qty_hash'] = this.get('costChangeReport').azQtyHash;
          }catch(e){
            errors. push('Please fill out the redundancy field with valid selected availability zone(s)');
          }

          var deliveryDateView = this.get("deliveryDateView")
          submissionHash['arrival_date'] = deliveryDateView.getChosenDate();
          if(deliveryDateView.isExpressDelivery()){
            submissionHash['standby'] = true;
          }

          var optional_keys = ['tag'];
          _.each(optional_keys, function(optional_key){
            if(!submissionHash[optional_key]){
              delete submissionHash[optional_key];
            }
          });

          var keys = _.keys(submissionHash);

          _.each(keys, function(key){
            log('Submission: ' + key + ' = ' + submissionHash[key] + ' of type ' + typeof(submissionHash[key]));
            if(submissionHash[key] == undefined || submissionHash[key] == ''){
              if(model.isClassicForm()){
                if(['dsm_choice', 'os_choice'].indexOf(key)!=-1){
                  delete submissionHash[key];
                }else if(key=='maws_detail'){
                  var mawsChoice = model.getLineComponentView('maws-choice', 0);
                  if(mawsChoice.needDetail())
                    errors.push(key + ' field is empty, please fill out before submission');
                  else
                    delete submissionHash[key];
                }else{
                  errors.push(key + ' field is empty, please fill out before submission');
                }
              }else{
                if(
                  (['stage', 'environment'].indexOf(key)!=-1 && model.getAWSGenre()=='fleet')
                    ||
                    (key == 'fleet' && model.getAWSGenre()=='environment')
                  ){
                  delete submissionHash[key];
                }else{
                  errors.push(key + ' field is empty, please fill out before submission');
                }
              }
            }

            if(model.isClassicForm()){
              if(key=='quantity'){
              var quantityPerAz = submissionHash['quantity'];
              if(quantityPerAz > 2000)
                errors.push(key + ' cannot be more than 2000');
              }
            }
          });
          if(errors.length > 0){
            throw errors.join(';');
          }
          return submissionHash;


          function gatherInfoByLine(line){
            try{
              switch(line){
                case 'redundancy':
                  var qtyPerAZ = model.getLineComponentModel(line, 0).getValue();
                  var AZs = model.getLineComponentModel(line, 1).getValue();
                  submissionHash.quantity = qtyPerAZ;
                  submissionHash.az_redundancy = AZs;
                  break;
                case 'email-cc-list':
                  var emailList = model.getLineComponentModel(line, 0).getValue();
                  if(emailList && emailList.length > 0){
                    var filteredList = _.reject(emailList, function(el){return !el});
                    submissionHash['cc_list'] = filteredList.join(',');
                  }
                  break;
                case 'cluster':
                  submissionHash[line] = model.getLineComponentView(line, 0).getText();
                  break;
                case 'az':
                  var AZs = model.getLineComponentModel(line,0).getValue();
                  submissionHash['datacenters'] = AZs;
                  break;
                case 'genre':
                  submissionHash['form_choice'] = model.getLineComponentModel(line, 0).getValue();
                  break;
                case 'server-family':
                  submissionHash['server_type'] = model.getLineComponentModel(line, 0).getValue();
                  break;
                case 'environment':
                  submissionHash['environment'] = model.getLineComponentModel('environment', 0).getValue();
                  submissionHash['stage'] = model.getLineComponentModel('environment', 1).getValue();
                  break;
                case 'os-dsm':
                  submissionHash['os_choice'] = model.getLineComponentModel('os-dsm', 0).getValue();
                  submissionHash['dsm_choice'] = model.getLineComponentModel('os-dsm', 1).getValue();
                  break;
                case 'maws-choice':
                  submissionHash['maws_choice'] = model.getLineComponentModel(line, 0).getValue();
                  break;
                case 'maws-detail':
                  submissionHash['maws_detail'] = model.getLineComponentModel(line, 0).getValue();
                  break;
                default: {
                  submissionHash[line] = model.getLineComponentModel(line, 0).getValue();
                }
              }
            }
            catch(error){
              throw (line + ": " + error);
            }
          }
        },
        placeOrder: function(){
          try{
            var entity = this.getEntity();
            var options = {};
            var formData = this.getFormHashForSubmission();
            this.set('formData', formData);
            options.data = formData;
            entity.order(options);
            //show progress bar and redirect headsup
            $('#submit').after(progress_bar());
            //start progress bar
            start_progress();
          }catch(error){
            //error is joined by ;
            if(typeof(error) == 'object')
              error = error.message
            var errors = error.split(';');
            this.trigger('showFormError', {errors: errors});
            stop_progress();
            $('#progress_container').remove();
          }
        },
        checkout: function(){
          try{
            var entity = this.getEntity();
            var options = {};
            options.data = this.get('formData');
            entity.checkout(options);
          }catch(error){
            //error is joined by ;
            if(typeof(error) == 'object')
              error = error.message
            var errors = error.split(';');
            this.trigger('showFormError', {errors: errors});
          }
        }
      });


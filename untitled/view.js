    var ExpressDeliveryView = Backbone.View.extend({
      initialize: function(){
        this.model = new ExpressDeliveryEligibility;
        this.listenTo(this.model, 'eligible', this.setEligible);
        this.listenTo(this.model, 'ineligible', this.setNotEligible);
        this.listenTo(this.model, 'setPending', this.setEligiblePending);
      },
      getCheckbox: function(){
        return this.$('input[type="checkbox"]');
      },
      removeCheckResult: function(){
        this.$('.eligible-check').remove();
      },
      disableCheckbox: function(){
        this.getCheckbox().attr('disabled', true);
      },
      enableCheckbox: function(){
        this.getCheckbox().removeAttr('disabled');
      },
      setEligible: function(){
        this.enableCheckbox();
        this.removeCheckResult();
        this.$el.append($('<div>',{class: 'positive eligible-check', text: 'eligible'}));
      },
      setEligiblePending: function(pendingInfo){
        this.disableCheckbox();
        this.removeCheckResult();
        this.$el.append($('<div>',{class: 'negative eligible-check', text: 'pending on ' + pendingInfo.pendingOnWhat.trim()}));
      },
      setNotEligible: function(params){
        this.disableCheckbox();
        this.removeCheckResult();
        var notEligible = $('<div>',{class: 'negative eligible-check', text: 'not eligible'});
        var explanation = $('<div>',{class: 'eligible-check-explans'});
        _.each(params.texts, function(text){
          explanation.append($('<div>',{class: 'eligible-check-explan', text: text}));
          explanation.hide();
        });
        notEligible.append(explanation);
        var model = this.model;
        model.set('explan', false);
        notEligible.mouseover(function(){
          if(!model.get('explan')){
            model.set('explan', true);
            explanation.show('blind');
          }
        });
        explanation.mouseleave(function(){
          var explan = model.get('explan');
          if(explan){
            explanation.hide({effect: 'blind', complete: function(){
              model.set('explan', false);
            }
            });
          }
        });
        this.$el.append(notEligible);
      }
    });
    
    var SupportiveView = Backbone.View.extend({
      initialize: function(){
        this.model = new Backbone.Model;
        this.model.set('isOpen', this.$el.css('display')!='none');
      },
      safeShow: function(callback){
        if(!this.isOpen()){
          if(callback != undefined){
            this.$el.show('blind',{complete: callback});
          }else{
            this.$el.show('blind');
          }
          this.model.set('isOpen', true);
        }else{
          if(callback!=undefined)
            callback();
        }
      },
      safeHide: function(callback){
        if(this.isOpen()){
          if(callback != undefined){
            this.$el.hide('blind',{complete: callback});
          }else{
            this.$el.hide('blind');
          }
          this.model.set('isOpen', false);
        }else{
          if(callback!=undefined)
            callback();
        }
      },
      isOpen: function(){
        return this.model.get('isOpen');
      }
    }).extend({
        loadContent: function(html){
          this.$el.find('.content-panel').html(html);
          return this;
        }
      });
    
    var LineView = Backbone.View.extend({
      initialize: function(){
        this.model = new LineModel;
        this.model.set('$el', this);
        this.model.set('inputs',[]);
        var id = this.$el.attr('class').split(/\s/)[1];
        this.model.set('id', id);
        if(this.$el.find('.supportive').length > 0){
          this.model.set('supportiveView', new SupportiveView({el: this.$el.find('.supportive')[0]}));
        }
        if(id!='genre'){
          var inputs = this.$el.find('input, select, .input, textarea');
          var model = this.model;
          inputs.each(function(index, el){
            model.get('inputs').push(new InputView({el: el}));
          });
        }else{
          this.model.get('inputs').push(new RadioView({el: $('.line.genre').find('input')}));
        }
      },
      events:{
        'mouseover': 'mouseover',
        'mouseout': 'mouseout'
      },
      mouseover: function(){
        this.$el.css('background', 'lightgoldenrodyellow');
      },
      mouseout: function(){
        this.$el.css('background', 'none');
      },
      inputs: function(){
        return this.model.get('inputs');
      },
      renderSupportiveView: function(){
        if(!this.model.get('supportiveView')){
          this.$el.append($('<div>',{class: 'supportive'}).append($('<div>',{class: 'content-panel'})));
          this.model.set('supportiveView', new SupportiveView({el: this.$('.supportive')}));
        }
      }
    });
    
    var InputView = Backbone.View.extend({
      initialize: function(options){
        var id = options.id || this.$el.attr('id');
        this.model = InputModelFactory.create(id);
        this.model.set('id', id);
        this.model.setValue(this.$el.val());
        this.model.set('type', this.$el.prop('tagName').toLowerCase());
        this.listenTo(this.model, 'updateValue', this.handleUpdateValue);
        var param = form_prefilled_values[id];
        if(param)
          this.model.set('param', param.trim ? param.trim() : param);
    
        if(this.model.get('type')=='select'){
          this.listenTo(this.model, 'selectUpdate', this.renderSelect);
        }
        if(id == 'az'){
          this.$el.chosen();
        }
        if(['email-cc-list', 'tag'].indexOf(this.model.get('id'))!=-1){
          this.$el.chosen({no_results_text: "Hit Tab To Add"});
          this.allowAddNewOptions();
        }
        if(id == 'show_optional'){
          this.onClick();
        }
      },
      events: {
        'change': 'onChange',
        'keydown': 'onKeyDown',
        'click': 'onClick',
        'fleet-picked': 'setFleet'
      },
      onChange: function(e){
        if(!this.model.isHostclassEquiv()){
          this.setValue({event: e});
        }
        log(this.model.get('id')+' is '+(this.$el.is(':focus') ? '':'not ')+'focused');
      },
      onKeyDown: function(event){
        if(this.model.isHostclassEquiv() && event.keyCode == 13 && this.model.id != 'fleet-selector'){
          this.setValue();
        }
        log(event);
      },
      setFleet: function(){
        this.setValue();
      },
      onClick: function(){
        var id = this.model.getID();
        if(id == 'tweak-by-az'){
          this.model.trigger('callForTweak');
        }else if(id == 'show_optional'){
          var checked = this.$el.is(':checked');
          this.model.setValue(checked);
        }
      },
      isChosenView: function(){
        if(['email-cc-list', 'tag', 'az'].indexOf(this.model.get('id'))!=-1){
          return true;
        }
        return false;
      },
      setValue: function(params){
        var currentValue = this.$el.val();
        if(currentValue != this.model.getValue()){
          this.model.setValue(currentValue);
          if(params && params.event && params.event.originalEvent){
            this.model.trigger('changeFromBrowser');
          }
        }
    
      },
      handleUpdateValue: function(event){
        this.updateValue(event.value);
      },
      updateValue: function(value){
        this.$el.val(value);
        this.model.setValue(value);
        this.$el.effect('highlight');
      }
    
    }).extend({
        // methods for select tags
        enableOtherOptions: function(){
          this.$el.find('option').removeAttr('disabled');
          this.$el.trigger('chosen:updated');
        },
        disableOtherOptions: function(){
          this.$el.find('option:not(:selected)').attr('disabled', true);
          this.$el.trigger('chosen:updated');
        },
        restrictOptionSize: function(size){
          var topItems = this.model.getValue().slice(0,size);
          this.$el.val(topItems);
          this.$el.change();
          this.$el.trigger('chosen:updated');
        },
        renderSelect: function(firstAsDefault){
          var vacantOption = "<option></option>";
          if(firstAsDefault){
            vacantOption = "";
          }
          this.$el.html(vacantOption);
          var options = this.model.get('selectList');
          if(options instanceof Array){
            var temp = "<% _.each(options, function(option) { %> <option value='<%= option['value'] || option %>'><%= option['name'] || option %></option> <% }); %>";
            this.$el.append(_.template(temp, {options: options}));
          }
          else{
            this.addGroupedOptions(options);
          }
          this.$el.change();
        },
        renderChosenSelect: function(options, allSelected){
          var temp = "<% _.each(options, function(option) { %> <option <%= allSelected? 'selected' : '' %> value='<%= option['value']||option %>' ><%= option['name']||option %></option> <% }); %>";
          this.$el.html(_.template(temp, {options: options, allSelected: allSelected}));
          this.$el.trigger("chosen:updated");
          if(allSelected)
            this.model.setValue(options);
        },
        getText: function(){
          return this.$el.find('option[value="'+this.model.getValue()+'"]').text();
        },
        addSelectOptions: function(texts, selected, holdingElem){
          if(!(texts instanceof Array)){
            texts = [texts];
          }
          var parent = holdingElem || this.$el;
          _.each(texts, function(text){
            var option = {text: text, value: text};
            option = selected ? _.extend(option, {selected: true}) : option;
    
            parent.append($('<option>', option));
          });
        },
        addGroupedOptions: function(groupHash){
          var groupNames = _.keys(groupHash);
          var view = this;
          _.each(groupNames, function(groupName){
            var optGroup = $('<optgroup>', {label: groupName});
            view.addSelectOptions(groupHash[groupName], false, optGroup);
            view.$el.append(optGroup);
          });
        }
      }).extend(LoaderModule).extend({
        //methods for chosen plugin
        hideClose: function(){
          if(this.model.getID()=='az'){
            var $closes = $('#az_chosen').find('.search-choice-close');
            $closes.hide();
          }
        },
        showClose: function(){
          if(this.model.getID()=='az'){
            var $closes = $('#az_chosen').find('.search-choice-close');
            $closes.show();
          }
        },
        //methods for email-cc-list & tags
        addChosenOptions: function(text){
          this.addSelectOptions(text, true);
          this.$el.trigger('chosen:updated');
          this.$el.change();
        },
        allowAddNewOptions: function(){
          var $textInput = this.$el.next('.chosen-container').find('input');
          $textInput.keydown($.proxy(function(event){
            log(event.which);
            if(event.which == TAB){
              event.preventDefault();
              var currentText=$textInput.val().trim();
              if(currentText.length > 0 && (!this.model.getValue() || this.model.getValue().indexOf(currentText) == -1)){
                this.model.setAdditionalEmail(currentText, $.proxy(this.addChosenOptions,this));
              }
            }
          },this));
        }
      }).extend({
        //maws function
        needDetail: function(){
          var mawsChoice = this.getText();
          if(mawsChoice == 'Other blocker')
            return true;
          else
            return false;
        }
      }).extend(PrefillModule);
    
    var RadioView = Backbone.View.extend({
      initialize: function(){
        this.model = InputModelFactory.create('radio');
        this.model.setID(this.$el.attr('name'));
        this.model.setValue(this.get$Checked().val());
        var param = this.$el.attr('param');
        if(param)
          this.model.set('param', param.trim());
      },
      get$Checked: function(){
        return this.$el.filter(':checked');
      },
      get$unChecked: function(){
        return this.$el.filter(':notchecked');
      },
      events: {
        'change': 'onChange'
      },
      onChange: function(){
        var value = this.get$Checked().val();
        if(!this.model.isLocked() && value != this.model.getValue()){
          this.model.lock();
          this.model.setValue(value);
        }
      }
    }).extend(PrefillModule);
    
    var TableView = Backbone.View.extend({
      initialize: function(){
        var name = this.$el.selector.match(/\w+/)[0];
        this.model = new TableModel({name: name});
    
        var switchView = new TableSwitchView({el: this.$el.prevAll('.switch')});
        this.listenTo(switchView.model, 'open', this.open);
        this.listenTo(switchView.model, 'close', this.close);
        this.model.set('switchView', switchView);
        this.model.set('$table', this.$el.find('table'));
        if(!this.model.get('switchView').isOpen()){
          this.$el.hide();
        }else{
          this.$el.show();
        }
      },
      reinitializeTable: function(){
        this.model.get('$table').fnDestroy();
        this.model.get('$table').dataTable(this.model.getDataTableConfig());
      },
      renderSpecificationTable: function(formChoice, tableData, serverTypes, cluster){
        this.model.set('tableData', tableData);
        var hash,capexAndMrcKeys;
        if(formChoice == 'Classic'){
          hash = this.model.get('classicSpecHash');
          capexAndMrcKeys = ['capex','mrc'];
        }
        else if (formChoice == 'AWS'){
          hash = this.model.get('awsSpecHash');
          capexAndMrcKeys = ['capex', 'aar'];
        }
        else{
          throw 'wrong form type: ' + formChoice;
        }
        var tableData = this.model.buildSpecificationTable(serverTypes, cluster, hash, capexAndMrcKeys);
        this.renderSelfExplanedTable(tableData);
      },
      renderSelfExplanedTable: function(tableData){
        var dataTableObject = this.model.getDataTableObject();
        if(dataTableObject!=undefined){
          dataTableObject.fnDestroy();
        }
        this.model.set('tableData', tableData);
        /*
         data
         header_row
         table_row
         cells(array)
         rows(array)
         table_row
         cells(array)
         */
        var data = this.model.getTableData();
        var temp =  "<thead><tr>"+
          "<% _.each(ths, function(th) { %>"+
          "<th><%= th %></th> <% }); %>"+
          "</tr></thead>"+
          "<tbody>"+
          "<% _.each(rows, function(row){ %>"+
          "<tr%>'><% _.each(row['table_row']['cells'], function(cell){ %>"+
          "<td><%= cell %></td> <% });%></tr>"+
          "<% });%>"+
          "</tbody>";
        this.model.get('$table').html(_.template(temp, {ths: data['header_row']['table_row']['cells'], rows: data['rows']}));
        if(this.model.get('switchView').isOpen()){
          this.model.get('switchView').$el.click();
        }
        dataTableObject = this.model.get('$table').dataTable(this.model.getDataTableConfig());
        this.model.setDataTableObject(dataTableObject);
        if(this.model.isSpecificationTable()){
          this.scrollWorkAroundFix();
        }
      },
      renderEc2InventoryTable: function(tableData, genre, ec2_inventory_route){
        var headerDic = genre == 'environment'? this.model.get('envHeaderDic') : this.model.get('fleetHeaderDic');
        this.model.set('tableData', tableData);
        this.model.set('headerDic', headerDic);
        //adjust monthly usage based on unused quantity
        _.each(tableData, function(row){
          var idle_ptg = parseFloat(row['idle_ptg'].match(/[0-9]+\.?[0-9]+/))/100;
          var total_aar = parseFloat(row['acc_aar'].match(/[0-9]+\.?[0-9]+/));
          row['acc_aar'] = '$'+(idle_ptg*total_aar).toFixed(2);
        });
        var temp =  "<thead><tr>"+
          "<% _.each(ths, function(th) { %>"+
          "<th><%= th %></th> <% }); %>"+
          "</tr></thead>"+
          "<tbody>"+
          "<% _.each(rows, function(row){ %>"+
          "<tr%>'><% _.each(dicKeys, function(key){ %>"+
          "<td><%= row[key] %></td> <% });%></tr>"+
          "<% });%>"+
          "</tbody>";
        if(this.model.get('switchView').isOpen()){
          this.model.get('switchView').$el.click();
        }
        var dataTableObject = this.model.getDataTableObject();
        if(dataTableObject)
          dataTableObject.fnDestroy();
        this.model.get('$table').html(_.template(temp, {rows: tableData, dicKeys: _.values(headerDic), ths: _.keys(headerDic)}));
    
        dataTableObject = this.model.get('$table').dataTable(this.model.getDataTableConfig());
        this.model.setDataTableObject(dataTableObject);
        //enable regex search
        dataTableObject.fnFilter('', null, true);
        //keydown in the search event will erase the auto-filter banner
        this.getFilterInput().keydown($.proxy(function(){
          this.clearFilterExplanation();
        }, this));
    
        this.$('.inv-table-anchor').remove();
        this.$el.append($('<a>',{href: ec2_inventory_route, target:'_blank', text: 'More Inventory Info', class: 'inv-table-anchor'}));
      },
      open: function(){
        this.$el.show('blind');
        this.model.set('isOpen', true);
      },
      close: function(){
        this.$el.hide('blind');
        this.model.set('isOpen', false);
      },
      isOpen: function(){
        return this.model.get('isOpen');
      },
      closeForLoading: function(){
        if(this.isOpen()){
          this.close();
        }
      },
      safeClose: function(){
        if(this.model.get('switchView').isOpen())
          this.clickSwitch();
      },
      safeOpen: function(){
        if(!this.model.get('switchView').isOpen() && this.model.isReadyForDisplay())
          this.clickSwitch();
      },
      clickSwitch: function(){
        this.model.get('switchView').onClick();
      },
      //ec2 inventory methods
      getFilterInput: function(){
        return this.$('.dataTables_filter').find('input');
      },
      filterTableWith: function(totalConditions){
        var $filterInput = this.getFilterInput();
        $filterInput.val(this.model.assembleFileterText(totalConditions));
        //trigger filter
        $filterInput.keyup();
        this.filterExplanation(totalConditions);
      },
      filterExplanation: function(totalConditions){
        var $explanationSection = $('.filter-explanation-wrapper');
        if($explanationSection.length ==0){
          $explanationSection = $('<div>', {class: 'filter-explanation-wrapper'});
          this.$el.prepend($explanationSection);
        }
        $explanationSection.html('');
        var $explanationTitle = $('<div>', {class: 'filter-explanation-title', text: 'Auto-filter Criteria'});
        $explanationSection.append($explanationTitle);
        var values = _.values(totalConditions);
        _.each(values, function(value){
          $explanationSection.append(keyword(value));
        });
        $explanationSection.show();
        function keyword(text){
          if(text.join!=undefined)
            text=text.join(',');
          return $('<div>',{class:'filter-keyword', text: text});
        }
      },
      clearFilterExplanation: function(){
        if(this.$('.filter-explanation-wrapper').css('display')!='none')
          this.$('.filter-explanation-wrapper').hide('blind');
      }
    }).extend({
        // funtions for specification table
        scrollTo: function(tableHeader, columnValue){
          var table = this.model.get('$table');
          var tableHeaders = this.$('tr>th');
          var columnIndex=-1;
          tableHeaders.each(function(index, elem){
            if($(elem).text()==tableHeader){
              columnIndex = index;
            }
          });
          if(columnIndex>=0){
            var td = table.find('tr>td:nth-child('+(columnIndex+1)+'):contains("'+columnValue+'")');
            var tr = td.parent();
            var top = table.find('tr:nth(0)').position().top;
            var position = tr.position();
            var scrollBody = this.$el.find('.dataTables_scrollBody');
            table.find('tr.spec-selected').removeClass('spec-selected');
            tr.addClass('spec-selected');
            scrollBody.animate({scrollTop: position.top-top+'px'});
          }else{
            throw 'scrollTo column not found';
          }
        },
        instantOpen: function(){
          this.$el.show();
        },
        instantClose: function(){
          this.$el.hide();
        },
        scrollWorkAroundFix: function(){
          this.instantOpen();
          this.model.getDataTableObject().fnDraw();
          this.instantClose();
        },
        updateCapexNMrc: function(cluster){
          var table = this.model.get('$table');
          var columnWidth = table.find('th').size();
          var capexCol = columnWidth - 1;
          var mrcCol = columnWidth ;
          var rows = table.find('tbody>tr');
          var dataHash = this.model.getCapexNMrcDataHash();
          var model = this.model;
          rows.each(function(index, row){
            var serverType = $(row).find('td:nth-child('+dataHash.serverCol+')').text();
            var capex = dollar_or_NA(dataHash.data[serverType].capex[cluster]);
            var mrcOrAar;
            if(model.get('isClassic'))
              mrcOrAar = dollar_or_NA(dataHash.data[serverType].mrc[cluster]);
            else
              mrcOrAar = dollar_or_NA(dataHash.data[serverType].aar[cluster]);
            if(model.get('isClassic')){
              $(row).find('td:nth-child('+capexCol+')').text(capex);
            }
            $(row).find('td:nth-child('+mrcCol+')').text(mrcOrAar);
          });
          this.reinitializeTable();
        }
      });
    
    var TableSwitchView = Backbone.View.extend({
      initialize: function(){
        this.model = new Backbone.Model;
        var state = this.$el.attr('class').split(/\s/).indexOf('icon-plus')==-1? 'open' : 'close'
        this.model.set('state', state);
      },
      events:{
        'click': 'onClick'
      },
      onClick: function(){
        if(this.isOpen()){
          this.$el.removeClass('icon-minus').addClass('icon-plus');
          this.model.set('state', 'close');
          this.model.trigger('close');
        }
        else{
          this.$el.removeClass('icon-plus').addClass('icon-minus');
          this.model.set('state', 'open');
          this.model.trigger('open');
        }
      },
      isOpen: function(){
        return this.model.get('state')=='open';
      }
    });
    
    var FormView = Backbone.View.extend({
      initialize: function(options){
        this.model = new FormModel({formChoice: options.formChoice});
        this.model.set('lines',new Backbone.Collection);
        this.model.set('fleetSelectors', this.fleetSelectorInitialize());
        var model = this.model;
        $('.line').each(function(index,el){
          model.get('lines').add((new LineView({el: el})).model);
        });
        this.model.set('inventoryTable', new TableView({el: $('.inventory-table')}));
        this.model.set('specTable', new TableView({el: $('.specification-table')}));
        this.model.setup();
        this.listenTo(this.model, 'showFormError', this.showFormError);
        this.listenTo(this.model, 'entityFetched', this.runPrefillScriptAfterEntityLoad);
      },
      showFormError: function(options){
        var infoBannerView = this.model.get('formInfoBannerView');
        if(!infoBannerView){
          infoBannerView = new InfoBannerView;
          this.model.set('formInfoBannerView', infoBannerView);
        }
        if(options && options.errors){
          var errors = options.errors;
          if(!$('.form-banner').size()){
            $('.form-wrapper').append($('<div>',{class: 'form-banner'}));
          }
          infoBannerView.createBanners(errors, 'negative').appendBannerIn($('.form-banner')).showBanner();
        }else{
          infoBannerView.removeAfterHide();
        }
      },
      fleetSelectorInitialize: function(){
        var selectors = new Backbone.Collection;
        $('.bt-fleet-selector').closest('.dd-container').each(function(index, element){
          selectors.push((new FleetSelectorWrapper({el: element})).model);
        });
        return selectors;
      },
      runPrefillScript: function(){
        try{
          var model = this.model;
          var fabricView = model.getLineComponentView('fabric', 0);
          fabricView.selectInOptions();
          if(model.isAWSForm()){
            var genreView = model.getLineComponentView('genre', 0);
            genreView.checkRadio();
          }
          var activeLineView = model.getLineComponentView(model.getActiveEntityOrginLineID(), 0);
          activeLineView.setValueAndEnter();
          this.model.set('prefillSuccess', true);
        }catch(e){
          this.model.set('prefillSuccess', false);
          log(e.message+'\n'+e.stack);
        }
      },
      runPrefillScriptAfterEntityLoad: function(){
        try{
          if(this.model.get('prefillSuccess')){
            var model = this.model;
            if(model.isAWSForm()&&model.getAWSGenre()=='environment'){
              var stageView = model.getLineComponentView('environment',1);
              stageView.selectInOptions();
            }
            var clusterView = model.getLineComponentView('cluster', 0);
            clusterView.selectInOptions();
            var serverTypeView = model.getLineComponentView('server-family',0);
            serverTypeView.selectInOptions();
            var azView = model.getLineComponentView('az', 0);
            azView.selectInChosenOptions();
            var qtyPerAZ = model.getLineComponentView('redundancy', 0);
            qtyPerAZ.setValueAndChange();
            var reasonView = model.getLineComponentView('reason', 0);
            reasonView.selectInOptions();
          }
        }catch(e){
          log(e.message+'\n'+e.stack);
        }
      }
    });
    
    var AppView = Backbone.View.extend({
      initialize: function(){
        this.hookUp$AutoComplete();
    
        this.model = new Backbone.Model;
        this.model.set('$content', $('.content'));
        var formSwitcher = new FormSwitcher({el: $('#classic_or_aws')});
        this.model.set('formSwitcher', formSwitcher);
        this.listenTo(formSwitcher.model, 'change', this.switchForm);
        this.initializeForms();
        this.runPrefillScript();
        this.listenTo(this.model.get('vpcEc2Form').model, 'startFetch', this.lockFromSwitcher);
        this.listenTo(this.model.get('vpcEc2Form').model, 'unlockFormSwithcer', this.unlockFormSwithcer);
        this.listenTo(this.model.get('legacyForm').model, 'startFetch', this.lockFromSwitcher);
        this.listenTo(this.model.get('legacyForm').model, 'unlockFormSwithcer', this.unlockFormSwithcer);
      },
      lockFromSwitcher: function(){
        this.model.get('formSwitcher').$el.attr('disabled', true);
      },
      unlockFormSwithcer: function(){
        this.model.get('formSwitcher').$el.removeAttr('disabled');
      },
      initializeForms: function(){
        var $parent = $('.content.legacy').parent();
        var $legacy = $('.content.legacy');
        var $vpc = $('.content.vpc-ec2');
        this.model.set('$parent', $parent);
        this.model.set('$legacy', $legacy);
        this.model.set('$vpc', $vpc);
    
        $legacy.detach();
        this.model.set('vpcEc2Form', new FormView({formChoice: 'AWS', $el: $('.content.vpc-ec2')}));
        $vpc.detach();
        $parent.append($legacy);
        this.model.set('legacyForm', new FormView({formChoice: 'Classic', $el: $('.content.legacy')}));
        $legacy.detach();
        this.switchForm();
      },
      switchForm: function(){
        var switcher = this.model.get('formSwitcher').model;
        var $Dic = {'Legacy': '$legacy', 'VPC EC2': '$vpc'};
        var Dic ={'Legacy': 'legacyForm', 'VPC EC2': 'vpcEc2Form'};
        var $parent = this.model.get('$parent');
        var $legacy = this.model.get('$legacy');
        var $vpc = this.model.get('$vpc');
        var $selected = this.model.get($Dic[switcher.getValue()]);
        this.model.set('activeForm', this.model.get(Dic[switcher.getValue()]));
        $legacy.detach();
        $vpc.detach();
        $parent.append($selected);
      },
      hookUp$AutoComplete: function(){
        hookUp$AutoCompleteByParams($('#hostclass'), '/api/hostclasses');
        hookUp$AutoCompleteByParams($('#environment'), '/hardware_request/environments');
        function hookUp$AutoCompleteByParams($el, url){
          $el.autocomplete({
            source: url,
            minLength: 3,
            select: function(event, ui) {
              log('select');
              $el.val(ui.item.value);
            },
            change: function(event,ui) {
              var e = jQuery.Event("keydown");
              e.keyCode = 13;
              $el.trigger(e);
            }
          });
        }
      },
      runPrefillScript: function(){
        try{
          var formSwitcherView = this.model.get('formSwitcher');
          formSwitcherView.selectInOptions();
          this.model.get('activeForm').runPrefillScript();
        }catch(e){
    
        }
      }
    }).extend(AjaxModule);
    
    var FormSwitcher = Backbone.View.extend({
      initialize: function(){
        this.model = new InputModel;
        this.model.setValue(this.$el.val());
        var param = this.$el.attr('param');
        if(param)
          this.model.set('param', param.trim());
      },
      events:{
        'change': 'onChange'
      },
      onChange: function(){
        this.model.setValue(this.$el.val());
      }
    }).extend(PrefillModule);
    
    
    var FleetSelectorWrapper = Backbone.View.extend({
      initialize: function(){
        this.model = new FleetSelectorStatus;
        this.model.setID(this.$el.find('.input').attr('id'));
        this.model.set('view',this);
        this.listenTo(this.model, 'live', this.activate);
        this.listenTo(this.model, 'die', this.deactivate);
        this.listenTo(this.model, 'valueChange', this.refreshBreadcrumb);
        this.$el.find('.input').on('focusin.input',$.proxy(function(){
          if(!this.model.get('isLive'))
            this.model.live();
        }, this));
      },
      refreshBreadcrumb: function(){
        this.$('.input').focusin();
      },
      toggle: function(){
        if(this.model.get('isLive')){
          this.activate();
        }else{
          this.deactivate();
        }
      },
      activate: function(){
        var me = this.$el;
        classDic.map(function(oldclass){
          me.find('.bt-'+oldclass).changeClass('bt-'+oldclass, oldclass);
        });
        load_dropdown_js();
        additional_js();
        me.find('.fleet-selector').focus();
      },
      deactivate: function(){
        var me = this.$el;
        var mymodel = this.model;
        me.find('.dropdown-box').hide();
        classDic.map(function(oldclass){
          me.find('.'+oldclass).changeClass(oldclass, 'bt-'+oldclass);
        });
        var f1 = $._data($('.input.'+this.model.get('ID')),'events')['focusin'][0]['handler'];
        me.find('*').off(); // get the dropdown events off the hook. For performance reason
        me.find('.input').on('focusin.input',f1);
    
        me.find('.bt-bread-crumb>span').click(function(e){
          var whichspan=e.currentTarget;
          mymodel.live();
          $('.bread-crumb>span').filter(function(){return $(this).text() == $(whichspan).text()}).click();
        });
      }
    }).extend(LoaderModule);
    
    var InfoBannerView = Backbone.View.extend({
      initialize: function(){
        this.model = new Backbone.Model;
      },
      createBanner: function(html, type){
        var $object = this.model.get('$object');
        if($object != undefined){
          this.removeBanner().actualCreateBanner(html,type);
        }else
          this.actualCreateBanner(html,type);
        return this;
      },
      createBanners: function(htmls, type){
        var $object = this.model.get('$object');
        if($object){
          this.removeBanner().actualCreateBanners(htmls,type);
        }else
          this.actualCreateBanners(htmls,type);
        return this;
      },
      actualCreateBanners: function(htmls, type){
        var types = ['positive', 'negative', 'neutral'];
        if(types.indexOf(type)!=-1){
          var $object = $('<div>', {class: 'info-banners ' + type});
          _.each(htmls, function(html){
            var $banner = $('<div>', {class: 'info-banner ' + type});
            $banner.text(html);
            $object.append($banner);
          });
          $object.css('display', 'none')
          this.model.set('$object', $object);
        }else{
          throw 'unkown banner type: ' + type;
        }
        return this;
      },
      actualCreateBanner: function(html, type){
        var types = ['positive', 'negative', 'neutral'];
        if(types.indexOf(type)!=-1){
          var $object = $('<div>', {class: 'info-banner ' + type});
          $object.html(html);
          $object.css('display', 'none')
          this.model.set('$object', $object);
        }else{
          throw 'unkown banner type: ' + type;
        }
        return this;
      },
      appendBannerIn: function($el){
        $el.append(this.model.get('$object'));
        return this;
      },
      showBanner: function(callback){
        var $object = this.model.get('$object');
        if($object!=undefined && $object.css('display')=='none'){
          if(callback!=undefined)
            $object.show('blind', {complete: callback});
          else
            $object.show('blind');
        }else{
          if(callback!=undefined)
            callback();
        }
        return this;
      },
      hideBanner: function(callback){
        var $object = this.model.get('$object');
        if($object!=undefined && $object.css('display')!='none'){
          if(callback!=undefined)
            $object.hide('blind', {complete: callback});
          else
            $object.hide('blind');
        }else{
          if(callback!=undefined)
            callback();
        }
        return this;
      },
      removeBanner: function(){
        if(this.hasBanner()){
          var $object = this.model.get('$object');
          $object.remove();
        }
        return this;
      },
      removeAfterHide: function(){
        if(this.hasBanner())
          this.hideBanner($.proxy(this.removeBanner, this));
      },
      hasBanner: function(){
        return this.model.get('$object')!=undefined;
      }
    });
    
    var CheckoutModalView = Backbone.View.extend({
      initialize: function(){
        this.model = new Backbone.Model;
        var $submit = this.$el.find('.modal-submit');
        var $close = this.$el.find('.modal-change');
        $submit.click($.proxy(this.onSubmitClick, this));
        $close.click($.proxy(this.onCloseClick, this));
      },
      //require a hash of name => value here
      reportTemplate: _.template(
        "<table class='summary-table'>"+
          "<tbody><%_.each(keys,function(key){%><tr><td class='option'><%=key%></td><td class='summary'><%=hash[key]%></td></tr><%});%></tbody>"+
          "</table>"),
      quantityTableTemplate: _.template(
        "<table class='quantity-summary'>"+
          "<tbody><%_.each(keys,function(key){%><tr><td class='option'><%=key%></td><td class='summary'><%=hash[key]%></td></tr><%});%></tbody>"+
          "</table>"),
      showModal: function(summary){
        this.fillContent(summary.report);
        //this is purely to prevent user from seeing a disabled submit button when using browser's go-back navigation
        this.$('.modal-submit').removeAttr('disabled'); 
        // if(summary.recycled_hardware_check && _.keys(summary.recycled_hardware_check).length > 0){
        //     var supportiveView = $('<div>',{class: 'supportive'}).html(junkyard_message_by_cluster(summary.params.fabric, summary.params.cluster));
        //     this.$('.summary-part').prepend(supportiveView);
        // }
        $('.summary-part').find('.regional-alert').remove();
        if(summary.regional_approval_check){
          var supportiveView = $('<div>',{class: 'supportive regional-alert'}).html("This request will require regional approval. Click <a href='https://w.amazon.com/index.php/Fleet_Management/CustomerInfo/Regional_Approvers' target='_blank'>here</a> to learn more.");
          this.$('.summary-part').prepend(supportiveView);
        }
    
        this.$el.dialog({
          modal: true,
          width: 1000,
          resizable: false,
          draggable: false,
          closeOnEscape: false,
          closeText: "hide",
          dialogClass: "no_title",
          open: function() {
            //adjust layout
            var $content = $('.checkout-modal>.content-part');
            $content.css('display', 'inline-block');
            var width = $content.width();
            $content.css({
              'width': width,
              'display': 'block',
              'margin': '0px auto 0px auto'
            });
          }
        });
      },
      fillContent: function(hash){
        //special case for quantity, pick it up here and insert after other lines have been filled in
        quantityHash = _.clone(hash['Quantity']);
        delete hash['Quantity'];
        keys = _.keys(hash);
    
        this.$el.find('.summary-table').remove();
        this.$el.find('.summary-part').append(this.reportTemplate({hash: hash, keys: keys}));
    
        var $table = this.$el.find('.summary-table');
        var $serverTypeLine = $table.find('td:contains("Server Type"), td:contains("Instance Type")').closest('tr');
        $serverTypeLine.after(
          "<tr>"+
            "<td class='option'>"+
            "Quantity"+
            "</td>"+
            "<td>"+
            this.quantityTableTemplate({hash: quantityHash, keys: _.keys(quantityHash)})+
            "</td>"+
            "</tr>"
        );
      },
      onSubmitClick: function(){
        this.submitIsOneWayTicket();
        this.model.trigger('checkout');
        var $submit = this.$el.find('.modal-submit');
        var $headsup = $('<div>',{class: 'redirect-headsup', text: 'You will be redirected to "View My Requests" page after checkout.'});
        $submit.after($headsup).after(progress_bar());
        $submit.attr('disabled', true);
        start_progress();
      },
      onCloseClick: function(){
        this.$el.dialog('close');
      },
      submitIsOneWayTicket: function(){
        var $close = this.$el.find('.modal-change');
        $close.parent().hide();
        var $submit = this.$el.find('.modal-submit');
        $submit.parent().css('border','none');
        var closeIcon = this.$el.find('.ui-icon-closethick');
        closeIcon.hide();
      },
      showError: function(checkoutJSON){
        stop_progress();
        $('#progress_container').remove();
        var infoBanner = this.model.get('infoBanner') || new InfoBannerView;
        this.model.set('infoBanner', infoBanner);
        infoBanner.createBanners(checkoutJSON.errors, 'negative').appendBannerIn(this.$el);
      }
    });
    
    var TweakFormView = Backbone.View.extend({
      tableBodyTemplate: _.template(
        "<% _.each(AZs, function(AZ){%>"+
          "<tr class='az-line'>"+
          "<td class='az-name'>"+
          "<%= AZ %>"+
          "</td>"+
          "<td class='az-qty'>"+
          "<input type='number' value='<%= value[AZ] %>'>"+
          "</td>"+
          "</tr>"+
          "<% });%>"
      ),
      initialize: function(options){
        this.model = new Backbone.Model;
        var azModel = options.azModel
        var qtyModel = options.qtyModel;
        this.model.set('azModel', azModel);
        this.model.set('qtyModel', qtyModel);
        this.listenTo(azModel, 'change', this.updateLines);
        this.initializeForm(qtyModel.getValue());
        this.listenTo(this.model, 'costChange', this.storeSnapShot);
      },
      initializeForm: function(initValue){
        var azModel = this.model.get('azModel');
        var azArray = azModel.getValue();
        var valueHash = {};
        var model = this.model;
        _.each(azArray, function(az){
          valueHash[az] = initValue;
        });
        this.templateTable(azArray,valueHash);
        //add a link to go back to evenly-distributed
        var goBackToEven = $('<div>',{class:'input', id: 'evenly-distributed', text: 'Use the same quantity for selected AZ’s'});
        this.$el.append(goBackToEven);
    
        //go back click setup
        goBackToEven.click(function(){
          model.trigger('callForEvenForm');
        });
      },
      updateLines: function(){
        var azModel = this.model.get('azModel');
        var azArray = azModel.getValue();
        var snapshot = this.getSnapshotCurrentTable();
        var valueHash = {};
        var model = this.model;
        _.each(azArray, function(AZ){
          valueHash[AZ] = snapshot[AZ] || model.get('qtyModel').getValue();
        });
        this.templateTable(azArray, valueHash);
      },
      getSnapshotCurrentTable: function(){
        var snapshot = {};
        var $trs = this.$el.find('tbody>tr');
        $.each($trs, function(index, el){
          var AZ = $(el).find('.az-name').text();
          var qty = $(el).find('.az-qty>input').val();
          snapshot[AZ] = qty;
        });
        return snapshot;
      },
      storeSnapShot: function(){
        var snapshot = this.getSnapshotCurrentTable();
        this.model.set('snapshot', snapshot);
      },
      getSnapShot: function(){
        return this.model.get('snapshot');
      },
      templateTable: function(AZs, value){
        this.$el.find('tbody').html(this.tableBodyTemplate({AZs: AZs, value: value}));
        var inputs = this.model.get('inputs');
        var view = this;
        _.each(inputs, function(input){
          view.stopListening(input, 'change', view.updateTotal);
        })
        //modelize the inputs
        inputs = new Backbone.Collection;
        $rows = this.$el.find('tbody>tr');
        $rows.each(function(index, el){
          var azName = $(el).find('.az-name').text();
          var inputView = new InputView({el: $(el).find(':input'), id: ('az-qty-'+azName)});
          inputs.push(inputView.model);
          view.listenTo(inputView.model, 'change', view.updateTotal);
        });
        this.model.set('inputs', inputs);
        this.updateTotal();
      },
      updateTotal: function(){
        var inputs = this.model.get('inputs');
        var values = inputs.pluck('value');
        var total = 0;
        if(values.length > 0)
          total = values.reduce(function(a,b){ return parseInt(a)+parseInt(b); });
        var $total = this.$el.find('.az-total');
        $total.text(total);
        this.model.set('total', total);
        this.model.trigger('costChange');
      },
      show: function(){
        if(this.$el.css('display')=='none'){
          this.$el.show();
        }
      },
      hide: function(){
        if(this.$el.css('display')!='none'){
          this.$el.hide();
        }
      },
      isVisible: function(){
        return this.$el.css('display') != 'none';
      },
      getTotal: function(){
        return this.model.get('total');
      }
    });

    var availableDates = [];

    function available(date) {
      dmy = formatDate(date);
      if ($.inArray(dmy, availableDates) > -1) {
        return [true, "","Available"];
      } else {
        return [false,"","unAvailable"];
      }
    }
    
    function formatDate(date){
      y = date.getFullYear(); 
      m = date.getMonth()+1 ;
      if(m < 10)
        m = "0" + m;
      d = date.getDate();
      if(d < 10)
        d = "0" + d;
      return y + "-" + m + "-" + d;
    }

    function areShallowArraysEqual(a1, a2) {
      return a1.length==a2.length && a1.every(function(v,i) { return v === a2[i]})
    }



    var DeliveryDateView = Backbone.View.extend({
      initialize: function() {
        this.model = new DeliveryDate();
        this.listenTo(this.model,'updateDateList',this.updateDateList);
        this.listenTo(this.model,'updateAsapMesage',this.updateAsapMesage);
        $('#delivery-date').datepicker({dateFormat: "yy-mm-dd", beforeShowDay: available});
      },
      syncModel: function(data){
        this.model.refresh(data);
      },
      events:{
        'change #isAsap_true': 'asapSelected',
        'change #isAsap_false': 'userChoiceSelected',
        'change #delivery-date': 'dateSelected'
      },
      asapSelected: function(data){
        var dates = this.model.get('dates');
        if(dates.length > 0){
          $('#delivery-date').val(availableDates[0]);
        }else{
          $('#delivery-date').val('');
        }
        $('#delivery-date').hide();
      },
      userChoiceSelected: function(data){
        $('#delivery-date').show();
      },
      dateSelected: function(data){
        $('#isAsap_false').prop('checked',true);
      },
      clearAll: function(){
        $('#express_delivery_true').hide();
        $('#express_delivery_false').hide();
        $('#delivery-date').val("");
        $('#isAsap_true').prop('checked',false);
        $('#isAsap_false').prop('checked',false);
        $('#delivery-date').hide();
        this.updateAsapMesage();
      },
      updateAsapMesage: function(){
        var asapMessage = "Earliest arrival date";
        if(this.model.get('expressible')){
          $('#express_delivery_true').show();
          $('#express_delivery_false').hide();
          asapMessage = "Immediately after approval";
        }else if(this.model.get('dates').length > 0){
          $('#express_delivery_false').show();
          $('#express_delivery_true').hide();
          asapMessage = "Earliest arrival date" + " ("+this.model.get('dates')[0]+")";
        }
        $('#asap label').text(asapMessage);
      },
      updateDateList: function(){
        this.clearAll();
        if ( !areShallowArraysEqual(availableDates, this.model.get('dates')) ) {
          availableDates = this.model.get('dates');
          var defaultDate = 0; //date picker will accept a relative date vi a number or an exact date. Hence the mixed typing
          if(availableDates.length > 0){
            var dateParts = availableDates[0].split("-");
            defaultDate = new Date(dateParts[0], dateParts[1] -1, dateParts[2]);
          }
          $('#delivery-date').datepicker('option','defaultDate',defaultDate);
        }
        this.setPrefilledArrivalDate(availableDates);
      },
      getChosenDate: function(){
        return $('#delivery-date').val();
      },
      isExpressDelivery: function(){
        return this.model.get('expressible') && $('#isAsap_true').prop('checked');
      },
      setPrefilledArrivalDate: function(availableDates) {
        if(form_prefilled_values.arrivalDate) {
          var thresholdDate = new Date(form_prefilled_values.arrivalDate);
          var campaignDate = null;

          if (availableDates.length > 0) {
            for (var i = 0; i < availableDates.length; i++) {
              var tmpDate = new Date(availableDates[i]);
              if (tmpDate >= thresholdDate) {
                campaignDate = availableDates[i];
                break;
              }
            }
            if (!campaignDate) {
              campaignDate = availableDates[availableDates.length - 1];
            }
          }
          if (campaignDate) {
            $('#delivery-date').datepicker('option', 'defaultDate', campaignDate);
            $('#delivery-date').datepicker("setDate", campaignDate);
            $('#express_delivery_false').show();
            $('#isAsap_false').prop('checked', true);
            $('#delivery-date').show();
          }
        }
      }
    });    

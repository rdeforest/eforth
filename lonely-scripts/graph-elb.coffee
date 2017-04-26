K2Input = K2.input(controls: [
  { name: 'accountId' }
  {
    name: 'region'
    type: 'dropdown'
    values: K2.Regions
  }
])
describeVpcs = K2Input.map((context) ->
  input = _.clone(context)
  ec2.describeVpcs(input).depaginate().pluck 'vpcs'
)
describeInternetGateways = K2Input.map((context) ->
  input = _.clone(context)
  ec2.describeInternetGateways(input).depaginate().pluck 'internetGateways'
)
describeVpnConnections = K2Input.map((context) ->
  input = _.clone(context)
  ec2.describeVpnConnections(input).depaginate()
)
describeCustomerGateways = K2Input.map((context) ->
  input = _.clone(context)
  ec2.describeCustomerGateways(input).depaginate()
)
describeVpnGateways = K2Input.map((context) ->
  input = _.clone(context)
  ec2.describeVpnGateways(input).depaginate().pluck 'vpnGateways'
)
describeAvailabilityZones = K2Input.map((context) ->
  input = _.clone(context)
  ec2.describeAvailabilityZones(input).pluck 'availabilityZones'
)
describeAvailabilityZoneMappings = K2Input.map((context) ->
  input = _.clone(context)
  input.args =
    accountId: context.accountId
    region: context.region
  ec2internal.describeAvailabilityZoneMappings(input).pluck 'externalToInternal'
)
describeSubnets = K2Input.map((context) ->
  input = _.clone(context)
  ec2.describeSubnets(input).depaginate().pluck 'subnets'
)
describeDBSubnetGroups = K2Input.map((context) ->
  input = _.clone(context)
  rds.describeDBSubnetGroups(input).depaginate().pluck 'dBSubnetGroups'
)
describeNetworkAcls = K2Input.map((context) ->
  input = _.clone(context)
  ec2.describeNetworkAcls(input).depaginate().pluck 'networkAcls'
)
describeRouteTables = K2Input.map((context) ->
  input = _.clone(context)
  ec2.describeRouteTables(input).depaginate().pluck 'routeTables'
)
describeInstances = K2Input.map((context) ->
  input = _.clone(context)
  ec2.describeInstances(input).depaginate().pluck('reservations').pluck 'instances'
)
describeAutoScalingGroups = K2Input.map((context) ->
  input = _.clone(context)
  asg.describeAutoScalingGroups(input).depaginate().pluck 'autoScalingGroups'
)
describeDBInstances = K2Input.map((context) ->
  input = _.clone(context)
  rds.describeDBInstances(input).depaginate().pluck 'dBInstances'
)
describeLoadBalancers = K2Input.map((context) ->
  input = _.clone(context)
  elb.describeLoadBalancers(input).depaginate().pluck 'loadBalancerDescriptions'
)
AccountID = K2Input.map((context) ->
  context.accountId
)
Region = K2Input.map((context) ->
  context.region
)
K2.Deferred.all(describeVpcs, describeInternetGateways, describeVpnConnections, describeCustomerGateways, describeVpnGateways, describeAvailabilityZones, describeAvailabilityZoneMappings, describeSubnets, describeDBSubnetGroups, describeNetworkAcls, describeRouteTables, describeInstances, describeAutoScalingGroups, describeDBInstances, describeLoadBalancers, AccountID, Region).spread (describeVpcs, describeInternetGateways, describeVpnConnections, describeCustomerGateways, describeVpnGateways, describeAvailabilityZones, describeAvailabilityZoneMappings, describeSubnets, describeDBSubnetGroups, describeNetworkAcls, describeRouteTables, describeInstances, describeAutoScalingGroups, describeDBInstances, describeLoadBalancers, AccountID, Region) ->

  arrayContains = (Array, Needle) ->
    a = undefined
    a = 0
    while a < Array.length
      if Array[a] == Needle
        return true
      a += 1
    false

  openEC2 = ->
    '<div class="ec2-block">' + printIconHeader('aws-icon aws-icon-ec2', 'EC2:', '25', '18')

  closeEC2 = ->
    '</div>'

  openRDS = ->
    '<div class="rds-block">' + printIconHeader('aws-icon aws-icon-rds', 'RDS:', '25', '18')

  closeRDS = ->
    '</div>'

  openAZ = (AZCount, ZoneName, InternalMapping) ->
    '<div class="az-wrapper az-' + AZCount + '">' + '<div class="az-block">' + '<h2>AZ: ' + ZoneName + '<br/>Internal: ' + InternalMapping + '</h2>'

  closeAZ = ->
    '</div></div>'

  openSubnet = (SubnetID, CIDRBlock, SubnetName, ACL, RouteTable, SubnetObject) ->
    '<div class="subnet-block">' + '<div href="#myModal" role="button" class="subnet-button btn" data-toggle="modal" onclick="showSubnetTable(\'' + SubnetID + '\', \'' + CIDRBlock + '\', \'' + SubnetName + '\', \'' + ACL + '\', \'' + RouteTable + '\', \'' + SubnetObject.state + '\', \'' + SubnetObject.availableIpAddressCount + '\', \'' + SubnetObject.defaultForAz + '\', \'' + SubnetObject.mapPublicIpOnLaunch + '\')">' + printIconHeader('aws-icon aws-icon-vpc', SubnetID, '0', '14') + SubnetName + '<br/>' + 'CIDR: ' + CIDRBlock + '</div>'

  closeSubnet = ->
    '</div>'

  openDBSubnetGroup = (SubnetGroupName, Subnets) ->
    Data = '<div class="subnet-block">' + '<h3>DB Subnet Group: ' + SubnetGroupName + '</h3>'
    _.each Subnets, (S) ->
      Data += '<div class="info"><strong>' + S.SubnetID + '</strong></div>'
      return
    Data

  closeDBSubnetGroup = ->
    '</div>'

  openASG = (ASGName, LaunchConfigurationName, MinSize, MaxSize, DesiredCapacity) ->
    '<div class="asg-block">' + '<h3>Autoscaling Group:</h3>' + '<div href="#myModal" role="button" class="asg-button btn btn-info" data-toggle="modal" onclick="showASGTable(\'' + ASGName + '\', \'' + LaunchConfigurationName + '\')">' + printIconHeader('aws-icon aws-icon-as', ASGName, '0', '14') + 'Min Size: ' + MinSize + ', Max Size: ' + MaxSize + '<br/>' + 'Desired Capacity: ' + DesiredCapacity + '</div>'

  closeASG = ->
    '</div>'

  openELB = (LoadBalancerName, LoadBalancerObject) ->
    '<div class="elb-block">' + printIconHeader('aws-icon aws-icon-elb', 'ELB:', '25', '18') + '<div href="#myModal" role="button" class="btn btn-warning" data-toggle="modal" onclick="showELBTable(\'' + LoadBalancerName + '\')">' + printIconHeader('aws-icon aws-icon-elb', LoadBalancerName, '25', '14') + '</div><br/>'

  closeELB = ->
    '</div>'

  printELBLines = (AZCount) ->
    LineColor = '#ccc'
    ELBLine = '<div style="background-color: ' + LineColor + '; width:2px; height:25px; margin:auto;"></div>'
    if AZCount > 1
      azc = 1
      while azc <= AZCount
        ELBLine += '<div class="az-wrapper az-' + AZCount + '">' + '<div style="height: 27px; position: relative; width: 100%;">'
        if azc == 1
          ELBLine += '<div style="position: absolute; left: 50%; background-color: ' + LineColor + '; width:50%; height:2px;"></div>' + '<div style="position: absolute; left: 50%; top: 2px; background-color: ' + LineColor + '; width:2px; height:25px;"></div>'
        else if azc == AZCount
          ELBLine += '<div style="position: absolute; background-color: ' + LineColor + '; width:calc(50% + 2px); height:2px;"></div>' + '<div style="position: absolute; left: 50%; top: 2px; background-color: ' + LineColor + '; width:2px; height:25px;"></div>'
        else
          ELBLine += '<div style="position: absolute; background-color: ' + LineColor + '; width:100%; height:2px;"></div>' + '<div style="position: absolute; left: 50%; top: 2px; background-color: ' + LineColor + '; width:2px; height:25px;"></div>'
        ELBLine += '</div></div>'
        azc += 1
    ELBLine

  printEC2Instance = (InstanceID, InstanceState, InstancePlatform, InstanceType, InstancePublicIP, InstancePrivateIP, InstanceObject) ->
    ButtonClass = 'btn'
    if InstanceState == 'pending'
      ButtonClass = 'btn btn-warning'
    if InstanceState == 'running'
      ButtonClass = 'btn btn-success'
    if InstanceState == 'shutting-down'
      ButtonClass = 'btn btn-warning'
    if InstanceState == 'terminated'
      ButtonClass = 'btn btn-danger'
    if InstanceState == 'stopping'
      ButtonClass = 'btn btn-warning'
    if InstanceState == 'stopped'
      ButtonClass = 'btn btn-inverse'
    InstanceIcons = ''
    if InstancePlatform
      InstanceIcons += '<div class="aws-icon aws-icon-ec2-windows"></div>'
    else
      InstanceIcons += '<div class="aws-icon aws-icon-ec2-linux"></div>'
    VolumeString1 = ''
    VolumeString2 = ''
    Counter = 0
    _.each InstanceObject.blockDeviceMappings, (BDM) ->
      if Counter > 0
        VolumeString1 += '<hr/>'
        VolumeString2 += ','
      VolumeString1 += BDM.ebs.volumeId + ' - ' + BDM.deviceName
      VolumeString2 += BDM.ebs.volumeId
      Counter += 1
      return
    ENIString1 = ''
    ENIString2 = ''
    Counter = 0
    _.each InstanceObject.networkInterfaces, (NI) ->
      if Counter > 0
        ENIString1 += '<hr/>'
        ENIString2 += ','
      ENIString1 += NI.networkInterfaceId + '<br/>- private: ' + NI.privateIpAddress + '<br/>- public: '
      if NI.association and NI.association.publicIp
        ENIString1 += NI.association.publicIp
      else
        ENIString1 += 'none'
      ENIString2 += NI.networkInterfaceId
      Counter += 1
      return
    SGString1 = ''
    SGString2 = ''
    Counter = 0
    _.each InstanceObject.securityGroups, (SG) ->
      if Counter > 0
        SGString1 += '<hr/>'
        SGString2 += ','
      SGString1 += SG.groupId
      SGString2 += SG.groupId
      Counter += 1
      return
    '<div href="#myModal" role="button" class="ec2-instance-block ' + ButtonClass + '" data-toggle="modal" onclick="showInstanceTable(\'' + InstanceID + '\', \'' + InstanceObject.imageId + '\', \'' + VolumeString1 + '\', \'' + VolumeString2 + '\', \'' + ENIString1 + '\', \'' + ENIString2 + '\', \'' + SGString1 + '\', \'' + SGString2 + '\');">' + printIconHeader('aws-icon aws-icon-ec2', InstanceID, '0', '14') + '<i>' + InstanceState + '</i><br/>' + InstanceType + '<br/>pub: ' + InstancePublicIP + '<br/>priv: ' + InstancePrivateIP + '<br/>' + InstanceIcons + '</div>'

  printRDSInstance = (InstanceID) ->
    '<div class="rds-instance-block">' + printIconHeader('aws-icon aws-icon-rds', InstanceID, '0', '14') + '</div>'

  printIconHeader = (IconClass, Header, Padding, FontSize) ->
    '<div style="padding: ' + Padding + 'px;"><table align="center"><tr><td><div class="' + IconClass + '"></div></td><td><strong style="font-size: ' + FontSize + 'px; line-height: 20px;">&nbsp;' + Header + '</strong></td></tr></table></div>'

  AZArray = []
  AZCounter = 0
  _.each describeAvailabilityZoneMappings, (DAZM) ->
    _.each describeAvailabilityZones, (DAZ) ->
      AZArray[AZCounter] = []
      AZArray[AZCounter]['AZ'] = DAZ.zoneName
      AZArray[AZCounter]['Region'] = DAZ.regionName
      AZArray[AZCounter]['AZInternalMapping'] = DAZM[DAZ.zoneName]
      AZCounter += 1
      return
    return
  EC2ClassicArray = []
  EC2ClassicArray['isEmpty'] = true
  EC2ClassicArray['EC2AZCount'] = 0
  EC2ClassicArray['RDSAZCount'] = 0
  AZCounter = 0
  EC2ClassicArray['EC2AZs'] = []
  _.each AZArray, (AZA) ->
    EC2ClassicArray['EC2AZs'][AZCounter] = []
    EC2ClassicArray['EC2AZs'][AZCounter]['isEmpty'] = true
    EC2ClassicArray['EC2AZs'][AZCounter]['ZoneName'] = AZA.AZ
    EC2ClassicArray['EC2AZs'][AZCounter]['InternalMapping'] = AZA.AZInternalMapping
    InstanceCounter = 0
    EC2ClassicArray['EC2AZs'][AZCounter]['Instances'] = []
    _.each describeInstances, (DI) ->
      if (!DI.vpcId or DI.vpcId == null) and AZA.AZ == DI.placement.availabilityZone
        EC2ClassicArray['EC2AZs'][AZCounter]['Instances'][InstanceCounter] = []
        if EC2ClassicArray['EC2AZs'][AZCounter]['isEmpty']
          EC2ClassicArray['EC2AZCount'] += 1
          EC2ClassicArray['isEmpty'] = false
          EC2ClassicArray['EC2AZs'][AZCounter]['isEmpty'] = false
        EC2ClassicArray['EC2AZs'][AZCounter]['Instances'][InstanceCounter]['InstanceID'] = DI.instanceId
        EC2ClassicArray['EC2AZs'][AZCounter]['Instances'][InstanceCounter]['InstanceState'] = DI.state.name
        EC2ClassicArray['EC2AZs'][AZCounter]['Instances'][InstanceCounter]['InstancePlatform'] = DI.platform
        EC2ClassicArray['EC2AZs'][AZCounter]['Instances'][InstanceCounter]['InstanceType'] = DI.instanceType
        EC2ClassicArray['EC2AZs'][AZCounter]['Instances'][InstanceCounter]['InstancePublicIP'] = DI.publicIpAddress
        EC2ClassicArray['EC2AZs'][AZCounter]['Instances'][InstanceCounter]['InstancePrivateIP'] = DI.privateIpAddress
        EC2ClassicArray['EC2AZs'][AZCounter]['Instances'][InstanceCounter]['InstanceObject'] = DI
        InstanceCounter += 1
      return
    AZCounter += 1
    return
  AZCounter = 0
  EC2ClassicArray['RDSAZs'] = []
  _.each AZArray, (AZA) ->
    EC2ClassicArray['RDSAZs'][AZCounter] = []
    EC2ClassicArray['RDSAZs'][AZCounter]['isEmpty'] = true
    EC2ClassicArray['RDSAZs'][AZCounter]['ZoneName'] = AZA.AZ
    EC2ClassicArray['RDSAZs'][AZCounter]['InternalMapping'] = AZA.AZInternalMapping
    InstanceCounter = 0
    EC2ClassicArray['RDSAZs'][AZCounter]['Instances'] = []
    _.each describeDBInstances, (DDBI) ->
      if (!DDBI.dBSubnetGroup or DDBI.dBSubnetGroup == null) and AZA.AZ == DDBI.availabilityZone
        EC2ClassicArray['RDSAZs'][AZCounter]['Instances'][InstanceCounter] = []
        if EC2ClassicArray['RDSAZs'][AZCounter]['isEmpty']
          EC2ClassicArray['RDSAZCount'] += 1
          EC2ClassicArray['isEmpty'] = false
          EC2ClassicArray['RDSAZs'][AZCounter]['isEmpty'] = false
        EC2ClassicArray['RDSAZs'][AZCounter]['Instances'][InstanceCounter]['InstanceID'] = DDBI.dBInstanceIdentifier
        EC2ClassicArray['RDSAZs'][AZCounter]['Instances'][InstanceCounter]['InstanceClass'] = DDBI.dBInstanceClass
        EC2ClassicArray['RDSAZs'][AZCounter]['Instances'][InstanceCounter]['Endpoint'] = DDBI.endpoint.address
        EC2ClassicArray['RDSAZs'][AZCounter]['Instances'][InstanceCounter]['Engine'] = DDBI.engine
        EC2ClassicArray['RDSAZs'][AZCounter]['Instances'][InstanceCounter]['EngineVersion'] = DDBI.engineVersion
        EC2ClassicArray['RDSAZs'][AZCounter]['Instances'][InstanceCounter]['Status'] = DDBI.dBInstanceStatus
        EC2ClassicArray['RDSAZs'][AZCounter]['Instances'][InstanceCounter]['InstanceObject'] = DDBI
        InstanceCounter += 1
      return
    AZCounter += 1
    return
  ELBCounter = 0
  EC2ClassicArray['ELBs'] = []
  _.each describeLoadBalancers, (DLB) ->
    if !DLB.vPCId or DLB.vPCId == null
      EC2ClassicArray['ELBs'][ELBCounter] = []
      EC2ClassicArray['ELBs'][ELBCounter]['isEmpty'] = true
      EC2ClassicArray['ELBs'][ELBCounter]['LoadBalancerName'] = DLB.loadBalancerName
      EC2ClassicArray['ELBs'][ELBCounter]['ELBAZCount'] = 0
      EC2ClassicArray['ELBs'][ELBCounter]['LoadBalancerObject'] = DLB
      AZCounter = 0
      EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'] = []
      _.each AZArray, (AZA) ->
        EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter] = []
        EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['isEmpty'] = true
        EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ZoneName'] = AZA.AZ
        EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['InternalMapping'] = AZA.AZInternalMapping
        EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['AutoscaledInstances'] = []
        ASGCounter = 0
        EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'] = []
        _.each describeAutoScalingGroups, (ASG) ->
          _.each ASG.loadBalancerNames, (LBN) ->
            if LBN == DLB.loadBalancerName
              _.each ASG.availabilityZones, (ASGAZ) ->
                if ASGAZ == AZA.AZ
                  if EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['isEmpty']
                    EC2ClassicArray['ELBs'][ELBCounter]['ELBAZCount'] += 1
                    EC2ClassicArray['ELBs'][ELBCounter]['isEmpty'] = false
                    EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['isEmpty'] = false
                  EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter] = []
                  EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter]['ASGName'] = ASG.autoScalingGroupName
                  EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter]['LaunchConfigurationName'] = ASG.launchConfigurationName
                  EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter]['MinSize'] = ASG.minSize
                  EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter]['MaxSize'] = ASG.maxSize
                  EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter]['DesiredCapacity'] = ASG.desiredCapacity
                  InstanceCounter = 0
                  EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter]['Instances'] = []
                  _.each ASG.instances, (I) ->
                    if I.availabilityZone == AZA.AZ
                      EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter]['Instances'][InstanceCounter] = []
                      _.each describeInstances, (DI) ->
                        if DI.instanceId == I.instanceId
                          EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter]['Instances'][InstanceCounter]['InstanceID'] = DI.instanceId
                          EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter]['Instances'][InstanceCounter]['InstanceState'] = DI.state.name
                          EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter]['Instances'][InstanceCounter]['InstancePlatform'] = DI.platform
                          EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter]['Instances'][InstanceCounter]['InstanceType'] = DI.instanceType
                          EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter]['Instances'][InstanceCounter]['InstancePublicIP'] = DI.publicIpAddress
                          EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter]['Instances'][InstanceCounter]['InstancePrivateIP'] = DI.privateIpAddress
                          EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ASGs'][ASGCounter]['Instances'][InstanceCounter]['InstanceObject'] = DI
                        return
                      EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['AutoscaledInstances'].push I.instanceId
                      InstanceCounter += 1
                    return
                  ASGCounter += 1
                return
            return
          return
        InstanceCounter = 0
        EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Instances'] = []
        _.each DLB.instances, (I) ->
          _.each describeInstances, (DI) ->
            if DI.instanceId == I.instanceId and DI.placement.availabilityZone == AZA.AZ and !arrayContains(EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['AutoscaledInstances'], I.instanceId)
              EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Instances'][InstanceCounter] = []
              if EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['isEmpty']
                EC2ClassicArray['ELBs'][ELBCounter]['ELBAZCount'] += 1
                EC2ClassicArray['ELBs'][ELBCounter]['isEmpty'] = false
                EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['isEmpty'] = false
              EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Instances'][InstanceCounter]['InstanceID'] = DI.instanceId
              EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Instances'][InstanceCounter]['InstanceState'] = DI.state.name
              EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Instances'][InstanceCounter]['InstancePlatform'] = DI.platform
              EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Instances'][InstanceCounter]['InstanceType'] = DI.instanceType
              EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Instances'][InstanceCounter]['InstancePublicIP'] = DI.publicIpAddress
              EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Instances'][InstanceCounter]['InstancePrivateIP'] = DI.privateIpAddress
              EC2ClassicArray['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Instances'][InstanceCounter]['InstanceObject'] = DI
              InstanceCounter += 1
            return
          return
        AZCounter += 1
        return
      ELBCounter += 1
    return
  VPCCounter = 0
  VPCArray = []
  _.each describeVpcs, (DV) ->
    VPCArray[VPCCounter] = []
    VPCArray[VPCCounter]['isEmpty'] = true
    VPCArray[VPCCounter]['EC2AZCount'] = 0
    VPCArray[VPCCounter]['RDSAZCount'] = 0
    VPCArray[VPCCounter]['VPCID'] = DV.vpcId
    VPCArray[VPCCounter]['CIDRBlock'] = DV.cidrBlock
    VPCArray[VPCCounter]['Name'] = 'unnamed'
    _.each DV.tags, (T) ->
      if T.key == 'Name'
        VPCArray[VPCCounter]['Name'] = T.value
      return
    VPCArray[VPCCounter]['IGW'] = []
    VPCArray[VPCCounter]['IGW']['ID'] = 'IGW does not exist'
    VPCArray[VPCCounter]['IGW']['Name'] = 'unnamed'
    _.each describeInternetGateways, (DIG) ->
      _.each DIG.attachments, (A) ->
        if DV.vpcId == A.vpcId
          VPCArray[VPCCounter]['IGW']['ID'] = DIG.internetGatewayId
          _.each DIG.tags, (T) ->
            if T.key == 'Name'
              VPCArray[VPCCounter]['IGW']['Name'] = T.value
            return
        return
      return
    VPCArray[VPCCounter]['VGW'] = []
    VPCArray[VPCCounter]['VGW']['ID'] = 'VGW does not exist'
    VPCArray[VPCCounter]['VGW']['Type'] = ''
    VPCArray[VPCCounter]['VGW']['Name'] = 'unnamed'
    _.each describeVpnGateways, (DVG) ->
      _.each DVG.vpcAttachments, (VA) ->
        if DV.vpcId == VA.vpcId
          VPCArray[VPCCounter]['VGW']['ID'] = DVG.vpnGatewayId
          VPCArray[VPCCounter]['VGW']['Type'] = DVG.type
          _.each DVG.tags, (T) ->
            if T.key == 'Name'
              VPCArray[VPCCounter]['VGW']['Name'] = T.value
            return
        return
      return
    AZCounter = 0
    VPCArray[VPCCounter]['EC2AZs'] = []
    _.each AZArray, (AZA) ->
      VPCArray[VPCCounter]['EC2AZs'][AZCounter] = []
      VPCArray[VPCCounter]['EC2AZs'][AZCounter]['isEmpty'] = true
      VPCArray[VPCCounter]['EC2AZs'][AZCounter]['ZoneName'] = AZA.AZ
      VPCArray[VPCCounter]['EC2AZs'][AZCounter]['InternalMapping'] = AZA.AZInternalMapping
      SubnetCounter = 0
      VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'] = []
      _.each describeSubnets, (DS) ->
        if DV.vpcId == DS.vpcId and AZA.AZ == DS.availabilityZone
          VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter] = []
          VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['isEmpty'] = true
          VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['SubnetID'] = DS.subnetId
          VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['CIDRBlock'] = DS.cidrBlock
          VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['Name'] = 'unnamed'
          _.each DS.tags, (T) ->
            if T.key == 'Name'
              VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['Name'] = T.value
            return
          VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['SubnetObject'] = DS
          VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['ACL'] = 'none'
          _.each describeNetworkAcls, (DNA) ->
            _.each DNA.associations, (A) ->
              if A.subnetId == DS.subnetId
                VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['ACL'] = DNA.networkAclId
              return
            return
          VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['RouteTable'] = 'none'
          _.each describeRouteTables, (DRT) ->
            _.each DRT.associations, (A) ->
              if A.subnetId == DS.subnetId
                VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['RouteTable'] = DRT.routeTableId
              return
            return
          InstanceCounter = 0
          VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'] = []
          _.each describeInstances, (DI) ->
            if DS.subnetId == DI.subnetId
              VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter] = []
              if VPCArray[VPCCounter]['EC2AZs'][AZCounter]['isEmpty']
                VPCArray[VPCCounter]['EC2AZCount'] += 1
                VPCArray[VPCCounter]['isEmpty'] = false
                VPCArray[VPCCounter]['EC2AZs'][AZCounter]['isEmpty'] = false
              VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['isEmpty'] = false
              VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter]['InstanceID'] = DI.instanceId
              VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter]['InstanceState'] = DI.state.name
              VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter]['InstancePlatform'] = DI.platform
              VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter]['InstanceType'] = DI.instanceType
              VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter]['InstancePublicIP'] = DI.publicIpAddress
              VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter]['InstancePrivateIP'] = DI.privateIpAddress
              VPCArray[VPCCounter]['EC2AZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter]['InstanceObject'] = DI
              InstanceCounter += 1
            return
          SubnetCounter += 1
        return
      AZCounter += 1
      return
    AZCounter = 0
    VPCArray[VPCCounter]['RDSAZs'] = []
    _.each AZArray, (AZA) ->
      VPCArray[VPCCounter]['RDSAZs'][AZCounter] = []
      VPCArray[VPCCounter]['RDSAZs'][AZCounter]['isEmpty'] = true
      VPCArray[VPCCounter]['RDSAZs'][AZCounter]['ZoneName'] = AZA.AZ
      VPCArray[VPCCounter]['RDSAZs'][AZCounter]['InternalMapping'] = AZA.AZInternalMapping
      SubnetGroupCounter = 0
      VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'] = []
      _.each describeDBSubnetGroups, (DDBSG) ->
        if DV.vpcId == DDBSG.vpcId
          VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter] = []
          VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['isEmpty'] = DDBSG.dBSubnetGroupName
          VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['SubnetGroupName'] = DDBSG.dBSubnetGroupName
          VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['SubnetGroupDescription'] = DDBSG.dBSubnetGroupDescription
          SubnetCounter = 0
          VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Subnets'] = []
          _.each DDBSG.subnets, (S) ->
            if AZA.AZ == S.subnetAvailabilityZone.name
              VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Subnets'][SubnetCounter] = []
              VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Subnets'][SubnetCounter]['isEmpty'] = true
              VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Subnets'][SubnetCounter]['SubnetID'] = S.subnetIdentifier
              SubnetCounter += 1
            return
          InstanceCounter = 0
          VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Instances'] = []
          _.each describeDBInstances, (DDBI) ->
            if DDBI.dBSubnetGroup and DDBI.dBSubnetGroup.dBSubnetGroupName and DDBSG.dBSubnetGroupName == DDBI.dBSubnetGroup.dBSubnetGroupName
              if AZA.AZ == DDBI.availabilityZone or DDBI.multiAZ == true and AZA.AZ == DDBI.secondaryAvailabilityZone
                VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Instances'][InstanceCounter] = []
                VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Instances'][InstanceCounter]['InstanceID'] = DDBI.dBInstanceIdentifier
                if AZA.AZ == DDBI.availabilityZone
                  VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Instances'][InstanceCounter]['InstanceID'] += '<br/>PRIMARY'
                else if DDBI.multiAZ == true and AZA.AZ == DDBI.secondaryAvailabilityZone
                  VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Instances'][InstanceCounter]['InstanceID'] += '<br/>FAILOVER'
                VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Instances'][InstanceCounter]['InstanceClass'] = DDBI.dBInstanceClass
                VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Instances'][InstanceCounter]['Endpoint'] = DDBI.endpoint.address
                VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Instances'][InstanceCounter]['Engine'] = DDBI.engine
                VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Instances'][InstanceCounter]['EngineVersion'] = DDBI.engineVersion
                VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Instances'][InstanceCounter]['Status'] = DDBI.dBInstanceStatus
                VPCArray[VPCCounter]['RDSAZs'][AZCounter]['SubnetGroups'][SubnetGroupCounter]['Instances'][InstanceCounter]['InstanceObject'] = DDBI
                if VPCArray[VPCCounter]['RDSAZs'][AZCounter]['isEmpty']
                  VPCArray[VPCCounter]['RDSAZCount'] += 1
                  VPCArray[VPCCounter]['isEmpty'] = false
                  VPCArray[VPCCounter]['RDSAZs'][AZCounter]['isEmpty'] = false
                InstanceCounter += 1
            return
          SubnetGroupCounter += 1
        return
      AZCounter += 1
      return
    ELBCounter = 0
    VPCArray[VPCCounter]['ELBs'] = []
    _.each describeLoadBalancers, (DLB) ->
      if DLB.vPCId and DV.vpcId == DLB.vPCId
        VPCArray[VPCCounter]['ELBs'][ELBCounter] = []
        VPCArray[VPCCounter]['ELBs'][ELBCounter]['isEmpty'] = true
        VPCArray[VPCCounter]['ELBs'][ELBCounter]['LoadBalancerName'] = DLB.loadBalancerName
        VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZCount'] = 0
        VPCArray[VPCCounter]['ELBs'][ELBCounter]['LoadBalancerObject'] = DLB
        AZCounter = 0
        VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'] = []
        _.each AZArray, (AZA) ->
          VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter] = []
          VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['isEmpty'] = true
          VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['ZoneName'] = AZA.AZ
          VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['InternalMapping'] = AZA.AZInternalMapping
          SubnetCounter = 0
          VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'] = []
          _.each describeSubnets, (DS) ->
            if DS.availabilityZone == AZA.AZ
              VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter] = []
              VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['isEmpty'] = true
              VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['SubnetID'] = DS.subnetId
              VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['CIDRBlock'] = DS.cidrBlock
              VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['Name'] = 'unnamed'
              _.each DS.tags, (T) ->
                if T.key == 'Name'
                  VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['Name'] = T.value
                return
              VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['AutoscaledInstances'] = []
              VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['SubnetObject'] = DS
              VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ACL'] = 'none'
              _.each describeNetworkAcls, (DNA) ->
                _.each DNA.associations, (A) ->
                  if A.subnetId == DS.subnetId
                    VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ACL'] = DNA.networkAclId
                  return
                return
              VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['RouteTable'] = 'none'
              _.each describeRouteTables, (DRT) ->
                _.each DRT.associations, (A) ->
                  if A.subnetId == DS.subnetId
                    VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['RouteTable'] = DRT.routeTableId
                  return
                return
              ASGCounter = 0
              VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'] = []
              _.each describeAutoScalingGroups, (ASG) ->
                _.each ASG.loadBalancerNames, (LBN) ->
                  if LBN == DLB.loadBalancerName
                    ASGSubnets = ASG.vPCZoneIdentifier.split(',')
                    if arrayContains(ASGSubnets, DS.subnetId)
                      ASGInstanceCounter = 0
                      VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter] = []
                      VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter]['ASGName'] = ASG.autoScalingGroupName
                      VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter]['LaunchConfigurationName'] = ASG.launchConfigurationName
                      VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter]['MinSize'] = ASG.minSize
                      VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter]['MaxSize'] = ASG.maxSize
                      VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter]['DesiredCapacity'] = ASG.desiredCapacity
                      VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter]['Instances'] = []
                      if VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['isEmpty']
                        VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZCount'] += 1
                        VPCArray[VPCCounter]['ELBs'][ELBCounter]['isEmpty'] = false
                        VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['isEmpty'] = false
                      VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['isEmpty'] = false
                      _.each DLB.instances, (I) ->
                        _.each describeInstances, (DI) ->
                          if DI.instanceId == I.instanceId and DI.placement.availabilityZone == AZA.AZ
                            _.each ASG.instances, (I2) ->
                              if I2.instanceId == DI.instanceId
                                VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter]['Instances'][ASGInstanceCounter] = []
                                VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter]['Instances'][ASGInstanceCounter]['InstanceID'] = DI.instanceId
                                VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter]['Instances'][ASGInstanceCounter]['InstanceState'] = DI.state.name
                                VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter]['Instances'][ASGInstanceCounter]['InstancePlatform'] = DI.platform
                                VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter]['Instances'][ASGInstanceCounter]['InstanceType'] = DI.instanceType
                                VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter]['Instances'][ASGInstanceCounter]['InstancePublicIP'] = DI.publicIpAddress
                                VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter]['Instances'][ASGInstanceCounter]['InstancePrivateIP'] = DI.privateIpAddress
                                VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['ASGs'][ASGCounter]['Instances'][ASGInstanceCounter]['InstanceObject'] = DI
                                VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['AutoscaledInstances'].push DI.instanceId
                                ASGInstanceCounter += 1
                              return
                          return
                        return
                      ASGCounter += 1
                  return
                return
              InstanceCounter = 0
              VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'] = []
              _.each DLB.instances, (I) ->
                _.each describeInstances, (DI) ->
                  if DI.instanceId == I.instanceId and DI.placement.availabilityZone == AZA.AZ and DI.subnetId == VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['SubnetID'] and !arrayContains(VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['AutoscaledInstances'], I.instanceId)
                    VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter] = []
                    if VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['isEmpty']
                      VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZCount'] += 1
                      VPCArray[VPCCounter]['ELBs'][ELBCounter]['isEmpty'] = false
                      VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['isEmpty'] = false
                    VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['isEmpty'] = false
                    VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter]['InstanceID'] = DI.instanceId
                    VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter]['InstanceState'] = DI.state.name
                    VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter]['InstancePlatform'] = DI.platform
                    VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter]['InstanceType'] = DI.instanceType
                    VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter]['InstancePublicIP'] = DI.publicIpAddress
                    VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter]['InstancePrivateIP'] = DI.privateIpAddress
                    VPCArray[VPCCounter]['ELBs'][ELBCounter]['ELBAZs'][AZCounter]['Subnets'][SubnetCounter]['Instances'][InstanceCounter]['InstanceObject'] = DI
                    InstanceCounter += 1
                  return
                return
              SubnetCounter += 1
            return
          AZCounter += 1
          return
        ELBCounter += 1
      return
    VPCCounter += 1
    return
  GridSize = '10px'
  FontFamily = 'Verdana'
  HTML = ''
  HTML += '<style type="text/css">' + '.vpc-block { ' + 'margin: 0px 0px ' + GridSize + ' 0px; ' + 'width: 100%; ' + 'border: 1px solid #e3e3e3; ' + 'border-radius: ' + GridSize + '; ' + 'text-align: center; ' + 'vertical-align: top; ' + ' } ' + '.igw-wrapper, .vgw-wrapper { ' + 'display: inline-block; ' + 'width: 50%; ' + 'vertical-align: top; ' + ' } ' + '.igw-block, .vgw-block { ' + 'margin: 0px ' + GridSize + ' ' + GridSize + ' ' + GridSize + '; ' + 'background-color: #eeeeee; ' + 'border: 1px solid #ddd; ' + 'border-radius: ' + GridSize + '; ' + 'height: 100%; ' + ' } ' + '.h1-wrapper { ' + 'display: inline-block; ' + 'width: 100%; ' + ' } ' + 'h1 { ' + 'margin: 0%; ' + 'padding: 25px; ' + 'font-family: ' + FontFamily + '; ' + 'font-size: 18px; ' + ' } ' + 'hr { ' + 'margin: 0px; ' + ' } ' + 'h2 { ' + 'margin: 0%; ' + 'padding: 25px; ' + 'font-family: ' + FontFamily + '; ' + 'font-size: 14px; ' + ' } ' + 'h3 { ' + 'margin: 0%; ' + 'padding: ' + GridSize + '; ' + 'font-family: ' + FontFamily + '; ' + 'font-size: 12px; ' + ' } ' + '.subnet-button { ' + 'display: block; ' + 'margin: ' + GridSize + '; ' + ' } ' + '.asg-button { ' + 'display: block; ' + 'margin: 0px ' + GridSize + ' ' + GridSize + ' ' + GridSize + '; ' + ' } ' + '.header-button { ' + 'width: 100%; ' + ' } ' + '.elb-block { ' + 'margin: 0px ' + GridSize + ' ' + GridSize + ' ' + GridSize + '; ' + 'border: 1px solid #e3e3e3; ' + 'border-radius: ' + GridSize + '; ' + 'background-color: #fff5d6; ' + 'text-align: center; ' + 'vertical-align: top; ' + ' } ' + '.az-wrapper { ' + 'display: inline-block; ' + 'vertical-align: top; ' + ' } ' + '.az-1 { ' + 'width: auto; ' + 'min-width: 50% ' + ' } ' + '.az-2 { ' + 'width: 50%; ' + ' } ' + '.az-3 { ' + 'width: 33%; ' + ' } ' + '.az-4 { ' + 'width: 25%; ' + ' } ' + '.az-5 { ' + 'width: 20%; ' + ' } ' + '.az-block { ' + 'margin: 0px ' + GridSize + ' ' + GridSize + ' ' + GridSize + '; ' + 'background-color: #eeeeee; ' + 'border: 1px solid #ddd; ' + 'border-radius: ' + GridSize + '; ' + 'max-height: 600px; ' + 'overflow: auto; ' + ' } ' + '.az-block h2 { ' + 'margin: 0%; ' + 'padding: 25px; ' + 'font-family: ' + FontFamily + '; ' + 'font-size: 14px; ' + ' } ' + '.asg-block { ' + 'margin: 0px ' + GridSize + ' ' + GridSize + ' ' + GridSize + '; ' + 'background-color: #d4ebff; ' + 'border: 1px solid #ccc; ' + 'border-radius: ' + GridSize + '; ' + 'display: block; ' + ' } ' + '.subnet-block { ' + 'margin: 0px ' + GridSize + ' ' + GridSize + ' ' + GridSize + '; ' + 'background-color: #f5f5f5; ' + 'border: 1px solid #ccc; ' + 'border-radius: ' + GridSize + '; ' + 'display: inline-block; ' + ' } ' + '.ec2-block { ' + 'margin: 0px ' + GridSize + ' ' + GridSize + ' ' + GridSize + '; ' + 'border: 1px solid #e3e3e3; ' + 'border-radius: ' + GridSize + '; ' + 'background-color: #d4ebff; ' + 'text-align: center; ' + 'vertical-align: top; ' + ' } ' + '.ec2-instance-block { ' + 'display: inline-block; ' + 'margin: 0px 0px ' + GridSize + ' ' + GridSize + '; ' + ' } ' + '.rds-block { ' + 'margin: 0px ' + GridSize + ' ' + GridSize + ' ' + GridSize + '; ' + 'border: 1px solid #e3e3e3; ' + 'border-radius: ' + GridSize + '; ' + 'background-color: #ffd7d6; ' + 'text-align: center; ' + 'vertical-align: top; ' + ' } ' + '.rds-instance-block { ' + 'display: inline-block; ' + 'margin: 0px 0px ' + GridSize + ' ' + GridSize + '; ' + 'background-color: #FF9999; ' + 'border: 1px solid #e3e3e3; ' + 'border-radius: ' + GridSize + '; ' + ' } ' + '.rds-instance-block p { ' + 'margin: 0%; ' + 'text-align: center; ' + 'padding: 15px; ' + 'font-family: ' + FontFamily + '; ' + 'font-size: 12px; ' + ' } ' + '.aws-icon { ' + 'display: inline-block; ' + 'height: 20px; ' + 'width: 20px; ' + 'background-repeat: no-repeat; ' + ' } ' + '.aws-icon-ec2 { ' + 'background-image: url(\'https://s3-us-west-2.amazonaws.com/see-vpc/aws-sprite.png\'); ' + 'background-position: -0px -24px; ' + ' } ' + '.aws-icon-ec2-linux { ' + 'background-image: url(\'https://s3-us-west-2.amazonaws.com/see-vpc/linux.png\'); ' + ' } ' + '.aws-icon-ec2-windows { ' + 'background-image: url(\'https://s3-us-west-2.amazonaws.com/see-vpc/windows.png\'); ' + ' } ' + '.aws-icon-as { ' + 'background-image: url(\'https://s3-us-west-2.amazonaws.com/see-vpc/as.png\'); ' + ' } ' + '.aws-icon-rds { ' + 'background-image: url(\'https://s3-us-west-2.amazonaws.com/see-vpc/aws-sprite.png\'); ' + 'background-position: -192px -24px; ' + ' } ' + '.aws-icon-elb { ' + 'background-image: url(\'https://s3-us-west-2.amazonaws.com/see-vpc/elb.png\'); ' + ' } ' + '.aws-icon-vpc { ' + 'background-image: url(\'https://s3-us-west-2.amazonaws.com/see-vpc/aws-sprite.png\'); ' + 'background-position: -224px -24px; ' + ' } ' + '</style>'

  document.showSubnetTable = (SubnetID, CIDRBlock, SubnetName, ACL, RouteTable, State, AvailableIpAddressCount, DefaultForAz, MapPublicIpOnLaunch) ->
    document.getElementById('myModalLabel').innerHTML = printIconHeader('aws-icon aws-icon-vpc', SubnetID, '0', '14')
    document.getElementById('myModalBody').innerHTML = '<table align="center" cellpadding="15">' + '<tr>' + '<td>' + '<strong>Name:</strong> ' + SubnetName + '<br/>' + '<strong>State:</strong> ' + State + '<br/>' + '<strong>CIDR Range:</strong> ' + CIDRBlock + '<br/>' + '<strong>Available IP Address Count:</strong> ' + AvailableIpAddressCount + '<br/>' + '<strong>Default for AZ:</strong> ' + DefaultForAz + '<br/>' + '<strong>Map Public IP on Launch:</strong> ' + MapPublicIpOnLaunch + '<br/>' + '</td>' + '<td>' + '<a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/ec2.describeSubnets?AccountID=' + AccountID + '&SubnetID=' + SubnetID + '&Region=' + Region + '&_run=1" target="_blank">ec2.describeSubnets</a>' + '</td>' + '</tr>' + '<tr>' + '<td>' + '<strong>ACL:</strong> ' + ACL + '</td>' + '<td>' + '<a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/ec2.describeNetworkAcls?AccountID=' + AccountID + '&ACLID=' + ACL + '&Region=' + Region + '&_run=1" target="_blank">ec2.describeNetworkAcls</a>' + '</td>' + '</tr>' + '<tr>' + '<td>' + '<strong>Route Table:</strong> ' + RouteTable + '</td>' + '<td>' + '<a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/ec2.describeRouteTables?AccountID=' + AccountID + '&RouteTableID=' + RouteTable + '&Region=' + Region + '&_run=1" target="_blank">ec2.describeRouteTables</a>' + '</td>' + '</tr>' + '</table>'
    return

  document.showASGTable = (ASGName, LaunchConfigurationName) ->
    document.getElementById('myModalLabel').innerHTML = printIconHeader('aws-icon aws-icon-as', ASGName, '0', '14')
    document.getElementById('myModalBody').innerHTML = '<table align="center" cellpadding="15">' + '<tr>' + '<td><strong>Launch Configuration:</strong><br/>' + LaunchConfigurationName + '</td>' + '<td>' + '<a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/asg.describeLaunchConfigurations?AccountID=' + AccountID + '&LaunchConfigurationName=' + LaunchConfigurationName + '&Region=' + Region + '&_run=1" target="_blank">asg.describeLaunchConfigurations</a>' + '</td>' + '</tr>' + '</table>'
    return

  document.showELBTable = (LoadBalancerName) ->
    document.getElementById('myModalLabel').innerHTML = printIconHeader('aws-icon aws-icon-elb', LoadBalancerName, '0', '14')
    document.getElementById('myModalBody').innerHTML = '<table align="center" cellpadding="15">' + '<tr>' + '<td>' + '<a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/elb.describeLoadBalancers?AccountID=' + AccountID + '&ELBName=' + LoadBalancerName + '&Region=' + Region + '&_run=1" target="_blank">elb.describeLoadBalancers</a>' + '</td>' + '</tr>' + '<tr>' + '<td>' + '<a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/elb.describeInstanceHealth?AccountID=' + AccountID + '&ELBName=' + LoadBalancerName + '&Region=' + Region + '&_run=1" target="_blank">elb.describeInstanceHealth</a>' + '</td>' + '</tr>' + '<tr>' + '<td>' + '<a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/elb.describeLoadBalancerPolicies?AccountID=' + AccountID + '&ELBName=' + LoadBalancerName + '&Region=' + Region + '&_run=1" target="_blank">elb.describeLoadBalancerPolicies</a>' + '</td>' + '</tr>' + '</table>'
    return

  document.showInstanceTable = (InstanceID, ImageID, VolumeString1, VolumeString2, ENIString1, ENIString2, SGString1, SGString2) ->
    document.getElementById('myModalLabel').innerHTML = printIconHeader('aws-icon aws-icon-ec2', InstanceID, '0', '14')
    document.getElementById('myModalBody').innerHTML = '<table align="center" cellpadding="15">' + '<tr>' + '<td><strong>Admiral:</strong></td>' + '<td>' + '<a class="btn btn-primary" href="https://admiral-iad.ec2.amazon.com/search?q=' + InstanceID + '" target="_blank">Open in Admiral</a>' + '</td>' + '</tr>' + '<tr>' + '<td valign="top"><strong>Instance ID:</strong><br/>' + InstanceID + '</td>' + '<td valign="top">' + '<strong>Options:</strong><br/>' + '<a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/ec2.describeInstances?AccountID=' + AccountID + '&InstanceID=' + InstanceID + '&Region=' + Region + '&_run=1" target="_blank">ec2.describeInstances</a><br/>' + '<a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/ec2.describeInstanceStatus?AccountID=' + AccountID + '&InstanceID=' + InstanceID + '&Region=' + Region + '&_run=1" target="_blank">ec2.describeInstanceStatus</a><br/>' + '<a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/EC2-Simple-Charts?AccountID=' + AccountID + '&InstanceID=' + InstanceID + '&Region=' + Region + '" target="_blank">Show All Cloudwatch Metrics</a>' + '</td>' + '</tr>' + '<tr>' + '<td valign="top"><strong>Image ID:</strong><br/>' + ImageID + '</td>' + '<td valign="top"><strong>Options:</strong><br/><a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/ec2.describeImages?AccountID=' + AccountID + '&ImageID=' + ImageID + '&Region=' + Region + '&_run=1" target="_blank">ec2.describeImages</a></td>' + '</tr>' + '<tr>' + '<td valign="top" nowrap><strong>Volume ID(s):</strong><br/>' + VolumeString1 + '</td>' + '<td valign="top">' + '<strong>Options:</strong><br/>' + '<a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/ec2.describeVolumes?AccountID=' + AccountID + '&VolumeID=' + VolumeString2 + '&Region=' + Region + '&_run=1" target="_blank">ec2.describeVolumes</a>' + '<a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/ec2.describeVolumeStatus?AccountID=' + AccountID + '&VolumeID=' + VolumeString2 + '&Region=' + Region + '&_run=1" target="_blank">ec2.describeVolumeStatus</a>' + '</td>' + '</tr>' + '<tr>' + '<td valign="top" nowrap><strong>ENI ID(s):</strong><br/>' + ENIString1 + '</td>' + '<td valign="top"><strong>Options:</strong><br/><a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/ec2.describeNetworkInterfaces?AccountID=' + AccountID + '&NetworkInterfaceID=' + ENIString2 + '&Region=' + Region + '&_run=1" target="_blank">ec2.describeNetworkInterfaces</a></td>' + '</tr>' + '<tr>' + '<td valign="top" nowrap><strong>Security Group(s):</strong><br/>' + SGString1 + '</td>' + '<td valign="top"><strong>Options:</strong><br/><a class="btn btn-primary" href="https://k2.amazon.com/workbench/scripts/aws/ec2.describeSecurityGroups?AccountID=' + AccountID + '&GroupID=' + SGString2 + '&Region=' + Region + '&_run=1" target="_blank">ec2.describeSecurityGroups</a></td>' + '</tr>' + '</table>'
    return

  if !EC2ClassicArray['isEmpty']
    HTML += '<div class="vpc-block">' + '<div class="h1-wrapper"><h1>EC2 Classic Network</h1></div><hr/>'
    EC2 = false
    _.each EC2ClassicArray['EC2AZs'], (EC2AZ) ->
      if !EC2AZ.isEmpty
        if !EC2
          HTML += openEC2()
          EC2 = true
        HTML += openAZ(EC2ClassicArray['EC2AZCount'], EC2AZ.ZoneName, EC2AZ.InternalMapping)
        _.each EC2AZ.Instances, (I) ->
          HTML += printEC2Instance(I.InstanceID, I.InstanceState, I.InstancePlatform, I.InstanceType, I.InstancePublicIP, I.InstancePrivateIP, I.InstanceObject)
          return
        HTML += closeAZ()
      return
    if EC2
      HTML += closeEC2()
    RDS = false
    _.each EC2ClassicArray['RDSAZs'], (RDSAZ) ->
      if !RDSAZ.isEmpty
        if !RDS
          HTML += openRDS()
          RDS = true
        HTML += openAZ(EC2ClassicArray['RDSAZCount'], RDSAZ.ZoneName, RDSAZ.InternalMapping)
        _.each RDSAZ.Instances, (I) ->
          HTML += printRDSInstance(I.InstanceID)
          return
        HTML += closeAZ()
      return
    if RDS
      HTML += closeRDS()
    _.each EC2ClassicArray.ELBs, (ELB) ->
      if !ELB.isEmpty
        HTML += openELB(ELB.LoadBalancerName, ELB.LoadBalancerObject)
        HTML += printELBLines(ELB.ELBAZCount)
        _.each ELB.ELBAZs, (ELBAZ) ->
          if !ELBAZ.isEmpty
            HTML += openAZ(ELB.ELBAZCount, ELBAZ.ZoneName, ELBAZ.InternalMapping)
            _.each ELBAZ.ASGs, (ASG) ->
              HTML += openASG(ASG.ASGName, ASG.LaunchConfigurationName, ASG.MinSize, ASG.MaxSize, ASG.DesiredCapacity)
              _.each ASG.Instances, (I) ->
                HTML += printEC2Instance(I.InstanceID, I.InstanceState, I.InstancePlatform, I.InstanceType, I.InstancePublicIP, I.InstancePrivateIP, I.InstanceObject)
                return
              HTML += closeASG()
              return
            _.each ELBAZ.Instances, (I) ->
              HTML += printEC2Instance(I.InstanceID, I.InstanceState, I.InstancePlatform, I.InstanceType, I.InstancePublicIP, I.InstancePrivateIP, I.InstanceObject)
              return
            HTML += closeAZ()
          return
        HTML += closeELB()
      return
    HTML += '</div>' + '</div>'
  _.each VPCArray, (VPC) ->
    if !VPC.isEmpty
      HTML += '<div class="vpc-block">' + '<div class="h1-wrapper"><h1>' + VPC.VPCID + ' (' + VPC.CIDRBlock + ')<br/>Name: ' + VPC.Name + '</h1></div>' + '<div class="igw-wrapper"><div class="igw-block"><h2>' + VPC.IGW.ID + '<br/>Name: ' + VPC.IGW.Name + '</h2></div></div>' + '<div class="vgw-wrapper"><div class="vgw-block"><h2>' + VPC.VGW.ID + ' ( ' + VPC.VGW.Type + ')<br/>Name: ' + VPC.VGW.Name + '</h2></div></div>'
      EC2 = false
      _.each VPC.EC2AZs, (EC2AZ) ->
        if !EC2AZ.isEmpty
          if !EC2
            HTML += openEC2()
            EC2 = true
          HTML += openAZ(VPC.EC2AZCount, EC2AZ.ZoneName, EC2AZ.InternalMapping)
          _.each EC2AZ.Subnets, (S) ->
            if !S.isEmpty
              HTML += openSubnet(S.SubnetID, S.CIDRBlock, S.Name, S.ACL, S.RouteTable, S.SubnetObject)
              _.each S.Instances, (I) ->
                HTML += printEC2Instance(I.InstanceID, I.InstanceState, I.InstancePlatform, I.InstanceType, I.InstancePublicIP, I.InstancePrivateIP, I.InstanceObject)
                return
              HTML += closeSubnet()
            return
          HTML += closeAZ()
        return
      if EC2
        HTML += closeEC2()
      RDS = false
      _.each VPC.RDSAZs, (RDSAZ) ->
        if !RDSAZ.isEmpty
          if !RDS
            HTML += openRDS()
            RDS = true
          HTML += openAZ(VPC.RDSAZCount, RDSAZ.ZoneName, RDSAZ.InternalMapping)
          _.each RDSAZ.SubnetGroups, (SG) ->
            HTML += openDBSubnetGroup(SG.SubnetGroupName, SG.Subnets)
            _.each SG.Instances, (I) ->
              HTML += printRDSInstance(I.InstanceID)
              return
            HTML += closeDBSubnetGroup()
            return
          HTML += closeAZ()
        return
      if RDS
        HTML += closeRDS()
      _.each VPC.ELBs, (ELB) ->
        if !ELB.isEmpty
          HTML += openELB(ELB.LoadBalancerName, ELB.LoadBalancerObject)
          HTML += printELBLines(ELB.ELBAZCount)
          _.each ELB.ELBAZs, (ELBAZ) ->
            if !ELBAZ.isEmpty
              HTML += openAZ(ELB.ELBAZCount, ELBAZ.ZoneName, ELBAZ.InternalMapping)
              _.each ELBAZ.Subnets, (S) ->
                if !S.isEmpty
                  HTML += openSubnet(S.SubnetID, S.CIDRBlock, S.Name, S.ACL, S.RouteTable, S.SubnetObject)
                  _.each S.ASGs, (ASG) ->
                    HTML += openASG(ASG.ASGName, ASG.LaunchConfigurationName, ASG.MinSize, ASG.MaxSize, ASG.DesiredCapacity)
                    _.each ASG.Instances, (I) ->
                      HTML += printEC2Instance(I.InstanceID, I.InstanceState, I.InstancePlatform, I.InstanceType, I.InstancePublicIP, I.InstancePrivateIP, I.InstanceObject)
                      return
                    HTML += closeASG()
                    return
                  _.each S.Instances, (I) ->
                    HTML += printEC2Instance(I.InstanceID, I.InstanceState, I.InstancePlatform, I.InstanceType, I.InstancePublicIP, I.InstancePrivateIP, I.InstanceObject)
                    return
                  HTML += closeSubnet()
                return
              HTML += closeAZ()
            return
          HTML += closeELB()
        return
      HTML += '</div>'
    return
  HTML += '<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">' + '<div class="modal-header">' + '<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>' + '<h3 id="myModalLabel">Modal header</h3>' + '</div>' + '<div id="myModalBody" class="modal-body">' + '<p></p>' + '</div>' + '<div class="modal-footer">' + '<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>' + '</div>' + '</div>'
  $('#output-content').append HTML
  return

# ---
# generated by js2coffee 2.1.0

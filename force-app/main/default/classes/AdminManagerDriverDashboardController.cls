public with sharing class AdminManagerDriverDashboardController 
{
    public static String query;
    public static String totalmileages{get;set;}
    public static String totalvariableamount{get;set;}
    public static String contactDataAsString {get; set;}
    public static String gaspriceforpreviosmonth {get; set;}
    public static String obj_current_contact_details {get;set;}
    public Integer obj_attachementsize {get;set;}
    public static String nameofEmployee{get;set;}
    public static String emailofEmployee{get;set;}
    public Integer obj_driverpacket_attachMVRsize {get;set;}
    public Integer obj_driverpacket_attachementsize {get;set;}
    public static Boolean showlastyear {get;set;}
    public static List<contact> obj_currect_contact {get;set;}
    public List<Attachment> obj_driver_insurance {get;set;}
    public List<Attachment> obj_driver_driverpacket {get;set;}
    public List<Attachment>  obj_driver_driverMVR {get;set;}
    public AdminManagerDriverDashboardController() 
    {
        obj_currect_contact = new List<contact>();
        obj_current_contact_details = getDriverDetails();
        obj_driver_driverMVR = new List<Attachment>();
        setEmployeeName();
        if(obj_currect_contact.size()>0)
        {
            gaspriceforpreviosmonth = WrapperUtils.getDriverGasPrice(obj_currect_contact[0].MailingState,obj_currect_contact[0].MailingCity);
        }
        obj_driver_insurance = new List<Attachment>();
        obj_driver_driverpacket = new List<Attachment>();
        obj_driver_insurance = [SELECT Id, Body, Name FROM Attachment WHERE ParentId =: ApexPages.currentPage().getParameters().get('id') and Name LIKE '%Insurance%' limit 1];
        obj_attachementsize = obj_driver_insurance.size();
        obj_driver_driverpacket = [SELECT Id, Body, Name FROM Attachment WHERE ParentId=:ApexPages.currentPage().getParameters().get('id') and Name LIKE '%Driver_Packet%' limit 1];
        obj_driverpacket_attachementsize = obj_driver_driverpacket.size();
        obj_driver_driverMVR = [SELECT Id, Body, Name FROM Attachment WHERE ParentId=:ApexPages.currentPage().getParameters().get('id') and Name LIKE '%MVR%' limit 1];
        obj_driverpacket_attachMVRsize = obj_driver_driverMVR.size();
    }
    public static String getAccountid()
    {
        if(ApexPages.currentPage().getParameters().containsKey('accid') && String.isNotBlank(ApexPages.currentPage().getParameters().get('accid')))
        {
           return ApexPages.currentPage().getParameters().get('accid');
        }
        else
        {
            return '';
        } 
    }
    public static void setEmployeeName() {
        Contact employee= [SELECT Name, External_Email__c FROM Contact WHERE id =: getAdminid()];
        if(employee!=null)
        {
            nameofEmployee= String.escapeSingleQuotes(employee.Name); // Name of the Employee
            emailofEmployee = employee.External_Email__c;
        }
        else
        {
            nameofEmployee='';
            emailofEmployee ='';
            
        }       
    }    
    public static String getManagerid()
    {
        // manager id
        if(ApexPages.currentPage().getParameters().containsKey('manid') && String.isNotBlank(ApexPages.currentPage().getParameters().get('manid')))
        {
           return ApexPages.currentPage().getParameters().get('manid');
        }
        else
        {
            return '';
        } 
    }
    public static String getAdminid()
    {
        
        if(ApexPages.currentPage().getParameters().containsKey('adminid') && String.isNotBlank(ApexPages.currentPage().getParameters().get('adminid')))
        {
           return ApexPages.currentPage().getParameters().get('adminid');
        }
        else
        {
            return '';
        } 
    }
    public static String getDriverid()
    {
        
        if(ApexPages.currentPage().getParameters().containsKey('id') && String.isNotBlank(ApexPages.currentPage().getParameters().get('id')))
        {
           return ApexPages.currentPage().getParameters().get('id');
        }
        else
        {
            return '';
        } 
    }
    public static PageReference getRedirected()
    {
        
        if(getManagerid()!=''&& getAccountid()!='' && getDriverid()!='')
        {
            return null;
        }
        else
        {
            // redirect to error page
            return null;
        }
        
    }
    public static String getLast2Years()
    {
        // getpastYearReimbursement();
        return String.escapeSingleQuotes(WrapperUtils.getpastYearReimbursement(getDriverid()));
        // return WrapperUtils.getLast2Years();
    }
    // public static void getpastYearReimbursement(){
        
    //     if(WrapperUtils.getpastYearReimbursement(getDriverid()) > 0)
    //     {
    //         showlastyear = true;
    //     }
    //     else
    //     {
    //         showlastyear = false;
    //     }   
    // }
    @RemoteAction
    public Static String getAllReimbursements(String year,String did,String accid) 
    {  
        return String.escapeSingleQuotes(WrapperUtils.getAllReimbursements(year,did,accid));
    }
    public static String getReimbursementsList()
    {   
        return String.escapeSingleQuotes(WrapperUtils.getReimbursementsList(getDriverid(),''));     
    }
    public static String getDriverDetails()
    {
            
        //List<contact> obj_currect_contact = new List<contact>();
        obj_currect_contact = [SELECT id,Name,MailingPostalCode,MailingState,MailingCity,
                                            Driver_Type__c,Fixed_Amount__c,compliancestatus__c,Car_Image__c,
                                            Accountid,Account.Name,Account.Logo_Document_Id__c,
                                            Vehicle_Type__c,Insurance_Attachment_Id__c,Maintenance__c,Tires__c,
                                            Insurance_Rate__c, License_Ragistration__c, Taxes__c,
                                            Depreciation__c, Total_Monthly_Costs__c, Business_Use__c 
                                        FROM Contact  
                                    WHERE Id =: getDriverid()];
        return String.escapeSingleQuotes(JSON.serialize(obj_currect_contact));
    }
    @RemoteAction
    public static String approveReimbursements(String year,String did,String accid,String reimbursements)
    {
        return WrapperUtils.approveReimbursements(year,did,accid,reimbursements);
    }
    @RemoteAction
    public static String approveMileages(String checked,String selected,String unapprove,String name,String emailaddress)
    {        
        System.debug('inside approveMileages'+ checked+selected+name+emailaddress);
        return WrapperUtils.approveMileagesForAdminDash(checked,selected,unapprove,name,emailaddress);
    }
    
    @RemoteAction
    public static String getMileages(String clickedMonth,string clickedYear,String did)
    {
        return String.escapeSingleQuotes(WrapperUtils.getMileages(clickedMonth,clickedYear,did));
    }

    public static String getDriverGasPrice(String MailingState,String MailingCity)
    {   
        return WrapperUtils.getDriverGasPrice(MailingState,MailingCity);
    }

    @RemoteAction
    public static String getReimbursementsListClone(String driverid)
    {
        return String.escapeSingleQuotes(WrapperUtils.getReimbursementsListClone(driverid));   
    }

    @RemoteAction
    public static List<String> getCompliance(String did)
    {
        return WrapperUtils.getComplianceCalculation(did,String.valueOf(System.today().year()));
        
    }
    @RemoteAction
    public static List<String> getPacketandMeeting(String did)
    {
        return WrapperUtils.getPacketandMeetingDetails(did);
    }
    
    //method is use for fatch mileages from triplog 
    //AI-000429
    @RemoteAction
    public static void TripCallout(Id driverId, String month, String year, String fuel, String maintTyre, Id empReID,String mpg,string status,string activityStatus){
        WrapperUtils.TripCallout(driverId,month,year,fuel,maintTyre,empReID,mpg,status,activityStatus);
    }

    //method is use for change reimbursement status 
    //AI-000429
    @RemoteAction
    public static void UpdateReimbursementStatus(Id empReID){
        WrapperUtils.UpdateReimbursementStatus(empReID);
    }

    //AI-000587 
    @RemoteAction
    public static List<BiweeklyPayPeriod.TimeAttedanceWrap> TimeAttendance(String conId,String year){
        return BiweeklyPayPeriod.getTimeAndAttendance(conId,year);
    }

    @RemoteAction
    public static String getMileagesBasedTandAtt(String startdate,String enddate,String did)
    {
        return String.escapeSingleQuotes(WrapperUtils.getMileagesBasedTA(startdate,enddate,did));
    } 

}
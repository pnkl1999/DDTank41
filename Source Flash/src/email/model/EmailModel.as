package email.model
{
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.TimeManager;
   import email.data.EmailInfo;
   import email.data.EmailInfoOfSended;
   import email.data.EmailState;
   import email.manager.MailManager;
   import email.view.EmailEvent;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class EmailModel extends EventDispatcher
   {
       
      
      public var isLoaded:Boolean = false;
      
      private var _sendedMails:Array;
      
      private var _noReadMails:Array;
      
      private var _emails:Array;
      
      private var _mailType:String = "all mails";
      
      private var _currentDate:Array;
      
      private var _state:String = "read";
      
      private var _currentPage:int = 1;
      
      private var _selectEmail:EmailInfo;
      
      public function EmailModel(target:IEventDispatcher = null)
      {
         this._sendedMails = [];
         this._emails = [];
         super(target);
      }
      
      public function set sendedMails(value:Array) : void
      {
         this._sendedMails = value;
         if(this._mailType == EmailState.SENDED)
         {
            dispatchEvent(new EmailEvent(EmailEvent.INIT_EMAIL));
         }
      }
      
      public function get sendedMails() : Array
      {
         return this._sendedMails;
      }
      
      public function get noReadMails() : Array
      {
         return this._noReadMails;
      }
      
      public function get emails() : Array
      {
         return this._emails.slice(0);
      }
      
      public function set emails(value:Array) : void
      {
         var remain:Number = NaN;
         this._emails = [];
         for(var i:int = 0; i < value.length; i++)
         {
            remain = this.calculateRemainTime(value[i].SendTime,value[i].ValidDate);
            if(remain > -1)
            {
               this._emails.push(value[i]);
            }
         }
         this.getNoReadMails();
         this.isLoaded = true;
         dispatchEvent(new EmailEvent(EmailEvent.INIT_EMAIL));
      }
      
      public function getValidateMails(arr:Array) : Array
      {
         var ei:EmailInfo = null;
         var result:Array = [];
         for(var i:int = 0; i < arr.length; i++)
         {
            ei = arr[i] as EmailInfo;
            if(ei)
            {
               if(MailManager.Instance.calculateRemainTime(ei.SendTime,ei.ValidDate) > 0)
               {
                  result.push(ei);
               }
            }
         }
         return result;
      }
      
      public function set mailType(value:String) : void
      {
         this._mailType = value;
         this.resetModel();
         dispatchEvent(new EmailEvent(EmailEvent.CHANGE_TYPE));
      }
      
      public function get mailType() : String
      {
         return this._mailType;
      }
      
      public function get currentDate() : Array
      {
         switch(this._mailType)
         {
            case EmailState.ALL:
               this._currentDate = this._emails;
               break;
            case EmailState.NOREAD:
               this._currentDate = this._noReadMails;
               break;
            case EmailState.SENDED:
               this._currentDate = this._sendedMails;
               break;
            default:
               this._currentDate = this._emails;
         }
         return this._currentDate;
      }
      
      public function set state(value:String) : void
      {
         this._state = value;
         dispatchEvent(new EmailEvent(EmailEvent.CHANE_STATE));
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      private function resetModel() : void
      {
         this._currentPage = 1;
         this.selectEmail = null;
      }
      
      public function get totalPage() : int
      {
         if(this.currentDate)
         {
            if(this.currentDate.length == 0)
            {
               return 1;
            }
            return Math.ceil(this.currentDate.length / 7);
         }
         return 1;
      }
      
      public function get currentPage() : int
      {
         if(this._currentPage > this.totalPage)
         {
            this._currentPage = this.totalPage;
         }
         return this._currentPage;
      }
      
      public function set currentPage(value:int) : void
      {
         this._currentPage = value;
         dispatchEvent(new EmailEvent(EmailEvent.CHANE_PAGE));
      }
      
      public function getNoReadMails() : void
      {
         var info:EmailInfo = null;
         this._noReadMails = [];
         for each(info in this._emails)
         {
            if(SharedManager.Instance.spacialReadedMail[PlayerManager.Instance.Self.ID] && SharedManager.Instance.spacialReadedMail[PlayerManager.Instance.Self.ID].indexOf(info.ID) > -1)
            {
               info.IsRead = true;
            }
            if(!info.IsRead)
            {
               this._noReadMails.push(info);
            }
         }
      }
      
      public function getMailByID(id:int) : EmailInfo
      {
         var le:int = this._emails.length;
         for(var i:uint = 0; i < le; i++)
         {
            if((this._emails[i] as EmailInfo).ID == id)
            {
               return this._emails[i] as EmailInfo;
            }
         }
         return null;
      }
      
      public function getViewData() : Array
      {
         var begin:int = 0;
         var end:int = 0;
         if(this._mailType == EmailState.NOREAD)
         {
            this.getNoReadMails();
         }
         var result:Array = new Array();
         if(this.currentDate)
         {
            begin = this.currentPage * 7 - 7;
            end = begin + 7 > this.currentDate.length ? int(int(int(this.currentDate.length))) : int(int(int(begin + 7)));
            result = this.currentDate.slice(begin,end);
         }
         return result;
      }
      
      private function calculateRemainTime(startTime:String, validHours:Number) : Number
      {
         var str:String = startTime;
         var startDate:Date = new Date(Number(str.substr(0,4)),Number(str.substr(5,2)) - 1,Number(str.substr(8,2)),Number(str.substr(11,2)),Number(str.substr(14,2)),Number(str.substr(17,2)));
         var nowDate:Date = TimeManager.Instance.Now();
         var remain:Number = validHours - (nowDate.time - startDate.time) / (60 * 60 * 1000);
         if(remain < 0)
         {
            return -1;
         }
         return remain;
      }
      
      public function get selectEmail() : EmailInfo
      {
         return this._selectEmail;
      }
      
      public function set selectEmail(value:EmailInfo) : void
      {
         if(value)
         {
            if(this._emails.indexOf(value) <= -1 && this._sendedMails.indexOf(value) <= -1)
            {
               this._selectEmail = null;
            }
            else
            {
               this._selectEmail = value;
            }
         }
         else
         {
            this._selectEmail = null;
         }
         dispatchEvent(new EmailEvent(EmailEvent.SELECT_EMAIL,this._selectEmail));
      }
      
      public function addEmail(info:EmailInfo) : void
      {
         this._emails.push(info);
         dispatchEvent(new EmailEvent(EmailEvent.ADD_EMAIL,info));
      }
      
      public function addEmailToSended(info:EmailInfoOfSended) : void
      {
         this._sendedMails.unshift(info);
         if(this._sendedMails.length > 21)
         {
            this._sendedMails.pop();
         }
      }
      
      public function removeFromNoRead(info:EmailInfo) : void
      {
         var index:int = this._noReadMails.indexOf(info);
         if(index > -1)
         {
            this._noReadMails.splice(index,1);
         }
      }
      
      public function removeEmail(info:EmailInfo) : void
      {
         var index:int = this._emails.indexOf(info);
         if(index > -1)
         {
            this._emails.splice(index,1);
            this.getNoReadMails();
            dispatchEvent(new EmailEvent(EmailEvent.REMOVE_EMAIL,info));
         }
      }
      
      public function changeEmail(info:EmailInfo) : void
      {
         var index:int = this._emails.indexOf(info);
         info.IsRead = true;
         if(index > -1)
         {
            dispatchEvent(new EmailEvent(EmailEvent.SELECT_EMAIL,info));
         }
      }
      
      public function clearEmail() : void
      {
         this._emails = new Array();
         dispatchEvent(new EmailEvent(EmailEvent.CLEAR_EMAIL));
      }
      
      public function dispose() : void
      {
         this._emails = new Array();
      }
      
      public function hasUnReadEmail() : Boolean
      {
         var info:EmailInfo = null;
         for each(info in this._emails)
         {
            if(!info.IsRead)
            {
               return true;
            }
         }
         return false;
      }
      
      public function hasUnReadGiftEmail() : Boolean
      {
         var info:EmailInfo = null;
         for each(info in this._emails)
         {
            if(!info.IsRead && info.MailType == 1)
            {
               return true;
            }
         }
         return false;
      }
   }
}

package ddt.dailyRecord
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ServerManager;
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class DailyRecordControl extends EventDispatcher
   {
      
      public static const RECORDLIST_IS_READY:String = "recordListIsReady";
      
      private static var _instance:DailyRecordControl;
       
      
      public var recordList:Vector.<DailiyRecordInfo>;
      
      public function DailyRecordControl()
      {
         super();
         this.recordList = new Vector.<DailiyRecordInfo>();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILYRECORD,this.daily);
         ServerManager.Instance.addEventListener(ServerManager.CHANGE_SERVER,this.__changeServerHandler);
      }
      
      public static function get Instance() : DailyRecordControl
      {
         if(_instance == null)
         {
            _instance = new DailyRecordControl();
         }
         return _instance;
      }
      
      private function __changeServerHandler(param1:Event) : void
      {
         this.recordList = new Vector.<DailiyRecordInfo>();
      }
      
      private function daily(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:DailiyRecordInfo = null;
         var _loc5_:int = 0;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new DailiyRecordInfo();
            _loc4_.type = param1.pkg.readInt();
            _loc4_.value = param1.pkg.readUTF();
            if(this.recordList.length == 0)
            {
               this.recordList.push(_loc4_);
            }
            else if(this.isUpdate(_loc4_.type))
            {
               _loc5_ = 0;
               while(_loc5_ < this.recordList.length)
               {
                  if(this.recordList[_loc5_].type == _loc4_.type)
                  {
                     this.recordList[_loc5_].value = _loc4_.value;
                     break;
                  }
                  if(_loc5_ == this.recordList.length - 1)
                  {
                     this.sortPos(_loc4_);
                     break;
                  }
                  _loc5_++;
               }
            }
            else
            {
               this.sortPos(_loc4_);
            }
            _loc3_++;
         }
         dispatchEvent(new Event(RECORDLIST_IS_READY));
      }
      
      private function sortPos(param1:DailiyRecordInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.recordList.length)
         {
            if(_loc2_ == this.recordList.length - 1)
            {
               if(param1.type < this.recordList[_loc2_].type)
               {
                  this.recordList.unshift(param1);
               }
               else
               {
                  this.recordList.push(param1);
               }
            }
            if(param1.type >= this.recordList[_loc2_].type && param1.type < this.recordList[_loc2_ + 1].type)
            {
               this.recordList.splice(_loc2_ + 1,0,param1);
               break;
            }
            _loc2_++;
         }
      }
      
      private function isUpdate(param1:int) : Boolean
      {
         switch(param1)
         {
            case 10:
            case 16:
            case 17:
            case 18:
            case 19:
            case 11:
            case 12:
            case 13:
            case 15:
            case 14:
            case 20:
               return true;
            default:
               return false;
         }
      }
      
      public function alertDailyFrame() : void
      {
         SocketManager.Instance.out.sendDailyRecord();
         var _loc1_:DailyRecordFrame = ComponentFactory.Instance.creatComponentByStylename("dailyRecordFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
   }
}

package consortion.view.selfConsortia.consortiaTask
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   
   public class ConsortiaTaskModel extends EventDispatcher
   {
      
      public static const RELEASE_TASK:int = 0;
      
      public static const RESET_TASK:int = 1;
      
      public static const SUMBIT_TASK:int = 2;
      
      public static const GET_TASKINFO:int = 3;
      
      public static const UPDATE_TASKINFO:int = 4;
      
      public static const SUCCESS_FAIL:int = 5;
       
      
      public var taskInfo:ConsortiaTaskInfo;
      
      public var isHaveTask_noRelease:Boolean = false;
      
      public function ConsortiaTaskModel(param1:IEventDispatcher = null)
      {
         super(param1);
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TASK_RELEASE,this.__releaseTaskCallBack);
      }
      
      private function __releaseTaskCallBack(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:String = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readByte();
         if(_loc3_ == SUMBIT_TASK)
         {
            _loc5_ = _loc2_.readBoolean();
            if(!_loc5_)
            {
               this.taskInfo = null;
            }
         }
         else if(_loc3_ == SUCCESS_FAIL)
         {
            _loc6_ = _loc2_.readBoolean();
            this.taskInfo = null;
         }
         else if(_loc3_ == UPDATE_TASKINFO)
         {
            _loc7_ = _loc2_.readInt();
            _loc8_ = _loc2_.readInt();
            _loc9_ = _loc2_.readInt();
            if(this.taskInfo != null)
            {
               this.taskInfo.updateItemData(_loc7_,_loc8_,_loc9_);
            }
         }
         else if(_loc3_ == RELEASE_TASK || _loc3_ == RESET_TASK)
         {
            _loc10_ = _loc2_.readInt();
            this.taskInfo = new ConsortiaTaskInfo();
            _loc11_ = 0;
            while(_loc11_ < _loc10_)
            {
               _loc12_ = _loc2_.readInt();
               _loc13_ = _loc2_.readUTF();
               this.taskInfo.addItemData(_loc12_,_loc13_);
               _loc11_++;
            }
         }
         else
         {
            _loc14_ = _loc2_.readInt();
            if(_loc14_ > 0)
            {
               this.taskInfo = new ConsortiaTaskInfo();
               _loc15_ = 0;
               while(_loc15_ < _loc14_)
               {
                  _loc16_ = _loc2_.readInt();
                  _loc17_ = _loc2_.readInt();
                  _loc18_ = _loc2_.readUTF();
                  _loc19_ = _loc2_.readInt();
                  _loc20_ = _loc2_.readInt();
                  _loc21_ = _loc2_.readInt();
                  this.taskInfo.addItemData(_loc16_,_loc18_,_loc17_,_loc19_,_loc20_,_loc21_);
                  _loc15_++;
               }
               this.taskInfo.sortItem();
               this.taskInfo.exp = _loc2_.readInt();
               this.taskInfo.offer = _loc2_.readInt();
               this.taskInfo.riches = _loc2_.readInt();
               this.taskInfo.buffID = _loc2_.readInt();
               this.taskInfo.beginTime = _loc2_.readDate();
               this.taskInfo.time = _loc2_.readInt();
            }
            else if(_loc14_ == -1)
            {
               this.taskInfo = null;
               this.isHaveTask_noRelease = true;
            }
            else
            {
               this.taskInfo = null;
            }
         }
         var _loc4_:ConsortiaTaskEvent = new ConsortiaTaskEvent(ConsortiaTaskEvent.GETCONSORTIATASKINFO);
         _loc4_.value = _loc3_;
         dispatchEvent(_loc4_);
      }
      
      public function showReleaseFrame() : void
      {
         if(this.taskInfo != null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.released"));
            return;
         }
         if(this.isHaveTask_noRelease)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.havetaskNoRelease"));
         }
         var _loc1_:ConsortiaReleaseTaskFrame = ComponentFactory.Instance.creatComponentByStylename("ConsortiaReleaseTaskFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}

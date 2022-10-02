package lightRoad.manager
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.DisplayObject;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import lightRoad.data.LightRoadPackageType;
   import lightRoad.dataAnalyzer.LightRoadDataAnalyzer;
   import lightRoad.info.LightGiftInfo;
   import lightRoad.loader.LoaderLightRoadUIModule;
   import lightRoad.model.LightRoadModel;
   import lightRoad.view.LightRoadHelpFrame;
   import lightRoad.view.MainFrame;
   import road7th.comm.PackageIn;
   
   public class LightRoadManager extends EventDispatcher
   {
      
      private static var _instance:LightRoadManager;
       
      
      private var _model:LightRoadModel;
      
      private var _MainFrame:MainFrame;
      
      private var _ShowMainFrame:Boolean = false;
      
      public function LightRoadManager(param1:PrivateClass)
      {
         super();
         if(param1 == null)
         {
            throw new Error("错误：LightRoadManager类属于单例，请使用本类的istance获取实例");
         }
      }
      
      public static function get instance() : LightRoadManager
      {
         if(LightRoadManager._instance == null)
         {
            LightRoadManager._instance = new LightRoadManager(new PrivateClass());
         }
         return LightRoadManager._instance;
      }
      
      public function get ShowMainFrame() : Boolean
      {
         return this._ShowMainFrame;
      }
      
      public function set ShowMainFrame(param1:Boolean) : void
      {
         this._ShowMainFrame = param1;
      }
      
      public function get model() : LightRoadModel
      {
         return this._model;
      }
      
      public function setup() : void
      {
         if(this._model == null)
         {
            this._model = new LightRoadModel();
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,this.pkgHandler);
      }
      
      private function openOrclose(param1:PackageIn) : void
      {
         if(param1 != null)
         {
            this._model.isOpen = param1.readBoolean();
         }
         if(this._model.isOpen)
         {
            this.showEnterIcon();
         }
         else
         {
            this.hideEnterIcon();
            this.dispose();
         }
      }
      
      private function upActivationDate(param1:PackageIn) : void
      {
         if(param1 != null)
         {
            this.model.thingsIntType = param1.readInt();
            this.model.ActivityStartTime = param1.readUTF();
            this.model.ActivityEndTime = param1.readUTF();
            this.upDataThingsType();
            this.upDataPointType();
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,null,LightRoadPackageType.UPMAINFRAMEDATA));
         }
      }
      
      private function upThingsDate(param1:PackageIn) : void
      {
         if(param1 != null)
         {
            this.model.thingsIntType = param1.readInt();
            this.upDataThingsType();
            this.upDataPointType();
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,null,LightRoadPackageType.UPMAINFRAMEDATA));
         }
      }
      
      public function returnPointType(param1:int) : Boolean
      {
         return (this.model.thingsIntType >> param1 & 1) == 0;
      }
      
      private function hideEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LIGHTROAD,false);
      }
      
      public function showEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LIGHTROAD,true);
      }
      
      public function templateDataSetup(param1:DataAnalyzer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:LightGiftInfo = null;
         if(param1 is LightRoadDataAnalyzer)
         {
            this.model.initThingsArray();
            _loc2_ = this.model.thingsXYArray.length;
            _loc3_ = "";
            _loc4_ = LightRoadDataAnalyzer(param1).dataList;
            _loc5_ = 0;
            _loc6_ = _loc4_.length;
            _loc7_ = 0;
            _loc8_ = 0;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc9_ = _loc4_[_loc5_] as LightGiftInfo;
               _loc9_.Space = _loc5_ + 1;
               this.model.thingsArray.push(_loc9_);
               _loc5_++;
            }
            this.upDataThingsType();
            this.upDataPointType();
         }
      }
      
      private function upDataThingsType() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = this.model.thingsType.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.returnPointType(_loc1_))
            {
               this.model.thingsType[_loc1_] = 0;
            }
            else
            {
               this.model.thingsType[_loc1_] = 1;
            }
            _loc1_++;
         }
         _loc2_ = this.model.thingsType.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.model.thingsArray[_loc1_].GetType = this.model.thingsType[_loc1_];
            _loc1_++;
         }
      }
      
      private function upDataPointType() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = this.model.pointGroup.length;
         var _loc3_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.model.pointGroup[_loc1_][0] - 1;
            this.model.thingsArray[_loc3_].Type = 1;
            _loc1_++;
         }
      }
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         switch(_loc3_)
         {
            case LightRoadPackageType.ACTIVATIONTYPE:
               this.openOrclose(_loc2_);
               break;
            case LightRoadPackageType.INACVATION:
               this.upActivationDate(_loc2_);
               break;
            case LightRoadPackageType.UPTHINGSMESSAGE:
               this.upThingsDate(_loc2_);
         }
      }
      
      public function onClicklightRoadIcon(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade < ServerConfigManager.instance.lightRoadLevel)
         {
            ServerConfigManager.instance.AuctionRate;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("lightRoad.MainFrame.PlayerGradeText",ServerConfigManager.instance.lightRoadLevel));
            return;
         }
         if(StateManager.currentStateType == StateType.MAIN)
         {
            LoaderLightRoadUIModule.Instance.loadUIModule(this.doOpenLightRoadFrame);
         }
      }
      
      public function dealWhithLightRoadEvent(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         switch(_loc3_)
         {
            case LightRoadPackageType.CLOSEMAINFRAME:
               this.closeMainFrame();
               break;
            case LightRoadPackageType.OPENHELPRAME:
               this.openHelpHandler();
         }
      }
      
      public function doOpenLightRoadFrame() : void
      {
         if(StateManager.currentStateType != StateType.MAIN)
         {
            StateManager.setState(StateType.LIGHTROAD_WINDOW);
         }
         else
         {
            this._ShowMainFrame = true;
            this.createMainFrame();
         }
      }
      
      public function createMainFrame() : void
      {
         if(!this._ShowMainFrame)
         {
            return;
         }
         SocketManager.Instance.out.sendLightRoadStarEnter();
         this._ShowMainFrame = false;
         this.closeMainFrame();
         this._MainFrame = ComponentFactory.Instance.creatComponentByStylename("lightRoad.MainFrame");
         LayerManager.Instance.addToLayer(this._MainFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._MainFrame.addEventListener(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,this.dealWhithLightRoadEvent);
      }
      
      public function closeMainFrame() : void
      {
         if(this._MainFrame)
         {
            this._MainFrame.addEventListener(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,this.dealWhithLightRoadEvent);
            this._MainFrame.dispose();
            this._MainFrame = null;
         }
      }
      
      public function DrawThings(param1:int) : void
      {
         SocketManager.Instance.out.lightRoadPointWork(param1);
      }
      
      private function openHelpHandler() : void
      {
         SoundManager.instance.play("008");
         var _loc1_:DisplayObject = ComponentFactory.Instance.creat("lightRoad.HelpPrompt");
         var _loc2_:LightRoadHelpFrame = ComponentFactory.Instance.creat("LightRoad.HelpFrame");
         _loc2_.setView(_loc1_);
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         if(this._MainFrame)
         {
            this.closeMainFrame();
         }
      }
   }
}

class PrivateClass
{
    
   
   function PrivateClass()
   {
      super();
   }
}

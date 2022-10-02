package ddt.view.roulette
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   
   public class RouletteBoxPanel extends Frame
   {
       
      
      private var _view:RouletteView;
      
      private var _templateIDList:Array;
      
      private var _keyCount:int;
      
      private var _oldBjYYVolNum:int;
      
      private var _oldYxYYVolNum:int;
      
      public function RouletteBoxPanel()
      {
         super();
         this.initII();
      }
      
      private function initII() : void
      {
         var _loc2_:BoxGoodsTempInfo = null;
         this._templateIDList = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < 18)
         {
            _loc2_ = new BoxGoodsTempInfo();
            _loc2_.TemplateId = 11013;
            _loc2_.IsBind = true;
            _loc2_.ItemCount = 2;
            _loc2_.ItemValid = 7;
            this._templateIDList.push(_loc2_);
            _loc1_++;
         }
         this._keyCount = 10;
         escEnable = true;
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._oldBjYYVolNum = SharedManager.Instance.musicVolumn;
         this._oldYxYYVolNum = SharedManager.Instance.soundVolumn;
         if(SharedManager.Instance.musicVolumn >= 25)
         {
            SharedManager.Instance.musicVolumn = 25;
         }
         SharedManager.Instance.soundVolumn = 80;
         SharedManager.Instance.changed();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            if(!this._view.isCanClose && this._view.selectNumber < 8)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.rouletteview.quit"));
            }
            else
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.rouletteview.close"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseII);
            }
         }
      }
      
      private function _responseII(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         ObjectUtils.disposeObject(param1.target);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.dispose();
         }
      }
      
      public function set templateIDList(param1:Array) : void
      {
         this._templateIDList = param1;
      }
      
      public function set keyCount(param1:int) : void
      {
         this._keyCount = param1;
      }
      
      public function show() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.view.rouletteView.title");
         this._view = ComponentFactory.Instance.creat("ddt.view.roulette.RouletteView",[this._templateIDList]);
         this._view.keyCount = this._keyCount;
         addToContent(this._view);
      }
      
      override public function dispose() : void
      {
         SharedManager.Instance.musicVolumn = this._oldBjYYVolNum;
         SharedManager.Instance.soundVolumn = this._oldYxYYVolNum;
         SharedManager.Instance.changed();
         removeEventListener(FrameEvent.RESPONSE,this._response);
         super.dispose();
         this._view = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

package ddt.view
{
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import feedback.FeedbackManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class DailyButtunBar extends Sprite implements Disposeable
   {
      
      private static var instance:DailyButtunBar;
       
      
      private var _inited:Boolean;
      
      private var _downLoadClientBtn:SimpleBitmapButton;
      
      private var _complainBtn:SimpleBitmapButton;
      
      private var _dailyBtn:SimpleBitmapButton;
      
      private var _complainShineEffect:IEffect;
      
      public function DailyButtunBar()
      {
         super();
         this._inited = false;
      }
      
      public static function get Insance() : DailyButtunBar
      {
         if(instance == null)
         {
            instance = new DailyButtunBar();
         }
         return instance;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._dailyBtn);
         this._dailyBtn = null;
         ObjectUtils.disposeObject(this._downLoadClientBtn);
         this._downLoadClientBtn = null;
         ObjectUtils.disposeObject(this._complainBtn);
         this._complainBtn = null;
         if(this._complainShineEffect)
         {
            EffectManager.Instance.removeEffect(this._complainShineEffect);
            this._complainShineEffect = null;
         }
         this._inited = false;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function hide() : void
      {
         this.dispose();
      }
      
      public function initView() : void
      {
         var _loc1_:Rectangle = null;
         if(this._inited)
         {
            return;
         }
         this._dailyBtn = ComponentFactory.Instance.creatComponentByStylename("toolbar.ShortCutBtn");
         if(PathManager.shortCutEnable())
         {
            this._dailyBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.shortcut");
            addChild(this._dailyBtn);
         }
         this._downLoadClientBtn = ComponentFactory.Instance.creatComponentByStylename("core.hall.clientDownloadBtn");
         this._downLoadClientBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.downLoadClient");
         if(PathManager.solveClientDownloadPath() != "")
         {
            if(!PathManager.shortCutEnable())
            {
               this._downLoadClientBtn.y = this._dailyBtn.y;
            }
            addChild(this._downLoadClientBtn);
         }
         this._downLoadClientBtn.addEventListener(MouseEvent.CLICK,this.__onActionClick);
         if(PathManager.solveFeedbackEnable())
         {
            this._complainBtn = ComponentFactory.Instance.creatComponentByStylename("toolbar.complainbtn");
            addChild(this._complainBtn);
            if(PathManager.solveClientDownloadPath() == "")
            {
               this._complainBtn.y -= 43;
            }
            _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.btnGlowRec");
            this._complainShineEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._complainBtn,"asset.feedback.btnGlow",_loc1_);
         }
         this.initEvent();
         this._inited = true;
      }
      
      private function __onActionClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         navigateToURL(new URLRequest(PathManager.solveClientDownloadPath()));
      }
      
      public function show() : void
      {
         this.initView();
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,false,0,false);
         if(FeedbackManager.instance.feedbackReplyData)
         {
            if(FeedbackManager.instance.feedbackReplyData.length <= 0)
            {
               this.setComplainGlow(false);
            }
            else
            {
               this.setComplainGlow(true);
            }
         }
      }
      
      public function setComplainGlow(param1:Boolean) : void
      {
         if(param1)
         {
            if(this._complainShineEffect)
            {
               this._complainShineEffect.play();
            }
         }
         else if(this._complainShineEffect)
         {
            this._complainShineEffect.stop();
         }
      }
      
      private function __onComplainClick(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         SoundManager.instance.play("015");
         try
         {
            FeedbackManager.instance.show();
            return;
         }
         catch(e:Error)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FEEDBACK);
            return;
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.FEEDBACK)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.FEEDBACK)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            FeedbackManager.instance.show();
         }
      }
      
      private function __onShortCutClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("015");
         var _loc2_:String = PathManager.solveLogin();
         var _loc3_:String = escape(_loc2_);
         if(ExternalInterface.available)
         {
            ExternalInterface.call("setFlashCall");
         }
         navigateToURL(new URLRequest("CreatShortCut.ashx?gameurl=" + _loc3_),"_blank");
      }
      
      private function initEvent() : void
      {
         if(this._dailyBtn)
         {
            this._dailyBtn.addEventListener(MouseEvent.CLICK,this.__onShortCutClick);
         }
         if(PathManager.solveFeedbackEnable())
         {
            this._complainBtn.addEventListener(MouseEvent.CLICK,this.__onComplainClick);
         }
      }
      
      private function removeEvent() : void
      {
         if(this._dailyBtn != null)
         {
            this._dailyBtn.removeEventListener(MouseEvent.CLICK,this.__onShortCutClick);
         }
         if(PathManager.solveFeedbackEnable())
         {
            if(this._complainBtn != null)
            {
               this._complainBtn.removeEventListener(MouseEvent.CLICK,this.__onComplainClick);
            }
         }
         if(this._downLoadClientBtn)
         {
            this._downLoadClientBtn.removeEventListener(MouseEvent.CLICK,this.__onActionClick);
         }
      }
   }
}

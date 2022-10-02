package store.forge.wishBead
{
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class WishTips extends Sprite implements Disposeable
   {
      
      public static const BEGIN_Y:int = 130;
       
      
      private var _timer:Timer;
      
      private var _successBit:Bitmap;
      
      private var _failBit:Bitmap;
      
      private var _moveSprite:Sprite;
      
      public var isDisplayerTip:Boolean = true;
      
      public function WishTips()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.init();
      }
      
      private function init() : void
      {
         this._successBit = ComponentFactory.Instance.creatBitmap("store.StoreIISuccessBitAsset");
         this._failBit = ComponentFactory.Instance.creatBitmap("store.StoreIIFailBitAsset");
         this._moveSprite = new Sprite();
         addChild(this._moveSprite);
         this._timer = new Timer(7500,1);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
      }
      
      private function createTween(param1:Function = null, param2:Array = null) : void
      {
         MessageTipManager.getInstance().kill();
         TweenMax.killTweensOf(this._moveSprite);
         TweenMax.from(this._moveSprite,0.4,{
            "y":BEGIN_Y,
            "alpha":0
         });
         TweenMax.to(this._moveSprite,0.4,{
            "delay":1.4,
            "y":BEGIN_Y * -1,
            "alpha":0,
            "onComplete":(param1 == null ? this.removeTips : param1),
            "onCompleteParams":param2
         });
      }
      
      public function showSuccess(param1:Function) : void
      {
         this.removeTips();
         if(this.isDisplayerTip)
         {
            if(!this._moveSprite)
            {
               this._moveSprite = new Sprite();
               addChild(this._moveSprite);
            }
            this._moveSprite.addChild(this._successBit);
            this.createTween(param1);
         }
         SoundManager.instance.pauseMusic();
         SoundManager.instance.play("063",false,false);
         this._timer.start();
         ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("wishBead.result"));
      }
      
      private function strengthTweenComplete(param1:String) : void
      {
         if(param1)
         {
            MessageTipManager.getInstance().show(param1);
         }
         this.removeTips();
      }
      
      public function showFail(param1:Function) : void
      {
         this.removeTips();
         if(this.isDisplayerTip)
         {
            if(!this._moveSprite)
            {
               this._moveSprite = new Sprite();
               addChild(this._moveSprite);
            }
            this._moveSprite.addChild(this._failBit);
            this.createTween(param1);
         }
         SoundManager.instance.pauseMusic();
         SoundManager.instance.play("064",false,false);
         this._timer.start();
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         this._timer.reset();
         SoundManager.instance.resumeMusic();
         SoundManager.instance.stop("063");
         SoundManager.instance.stop("064");
      }
      
      private function removeTips() : void
      {
         if(this._moveSprite && this._moveSprite.parent)
         {
            while(this._moveSprite.numChildren)
            {
               this._moveSprite.removeChildAt(0);
            }
            TweenMax.killTweensOf(this._moveSprite);
            this._moveSprite.parent.removeChild(this._moveSprite);
            this._moveSprite = null;
         }
      }
      
      public function dispose() : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this._timer.stop();
         this._timer = null;
         TweenMax.killTweensOf(this._moveSprite);
         SoundManager.instance.resumeMusic();
         SoundManager.instance.stop("063");
         SoundManager.instance.stop("064");
         this.removeTips();
         if(this._successBit)
         {
            ObjectUtils.disposeObject(this._successBit);
         }
         this._successBit = null;
         if(this._failBit)
         {
            ObjectUtils.disposeObject(this._failBit);
         }
         this._failBit = null;
         if(this._moveSprite)
         {
            ObjectUtils.disposeObject(this._moveSprite);
         }
         this._moveSprite = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

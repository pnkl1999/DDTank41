package game.view.tool
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.LivingEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.view.tips.ChangeNumToolTip;
   import ddt.view.tips.ChangeNumToolTipInfo;
   import ddt.view.tips.ToolPropInfo;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import game.GameManager;
   import game.model.LocalPlayer;
   import game.model.Player;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   
   public class DanderStrip extends Sprite implements Disposeable
   {
       
      
      private var _specialEnabled:Boolean = true;
      
      private var _movie:MovieClip;
      
      private var _danderStrip:Bitmap;
      
      private var _mask:Shape;
      
      private var _skillBtn:Sprite;
      
      private var _info:LocalPlayer;
      
      private var _danderStripTip:ChangeNumToolTip;
      
      private var _danderStripTipInfo:ChangeNumToolTipInfo;
      
      private var _danderStripCopy:Sprite;
      
      private var _btn:SimpleBitmapButton;
      
      private var _btn2:SimpleBitmapButton;
      
      private var _danderField:FilterFrameText;
      
      private var _isDisable:Boolean;
      
      private var _enable:Boolean = true;
      
      public function DanderStrip()
      {
         super();
         mouseEnabled = false;
         this._info = GameManager.Instance.Current.selfGamePlayer;
         this._danderStrip = ComponentFactory.Instance.creatBitmap("asset.game.danderStripAsset");
         addChild(this._danderStrip);
         this._mask = new Shape();
         this._mask.graphics.beginFill(16711680,1);
         this._mask.graphics.drawRect(0,0,-96,41);
         this._mask.graphics.endFill();
         this._mask.x = 124;
         this._mask.y = 4;
         addChild(this._mask);
         this._mask.width = 0;
         this._danderStrip.mask = this._mask;
         this._danderStripCopy = new Sprite();
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.game.danderStripAsset");
         addChild(this._danderStripCopy);
         this._danderStripCopy.addChild(_loc1_);
         this._danderStripCopy.alpha = 0;
         this.addDanderStripTip();
         this._movie = ClassUtils.CreatInstance("asset.game.danderCartoonAsset") as MovieClip;
         addChild(this._movie);
         this._movie.gotoAndStop(1);
         this._movie.mouseEnabled = false;
         this._movie.mouseChildren = false;
         this._btn = new SimpleBitmapButton();
         addChild(this._btn);
         this._btn.mouseChildren = true;
         this._btn.buttonMode = false;
         this._skillBtn = new Sprite();
         this._skillBtn.graphics.beginFill(16777215,1);
         this._skillBtn.graphics.drawCircle(0,0,22);
         this._skillBtn.graphics.endFill();
         this._skillBtn.x = 22;
         this._skillBtn.y = 17;
         this._skillBtn.alpha = 0;
         this._btn.addChild(this._skillBtn);
         this._btn2 = new SimpleBitmapButton();
         addChild(this._btn2);
         this._btn2.mouseChildren = true;
         this._btn2.buttonMode = false;
         this._btn.tipStyle = "core.ToolPropTips";
         this._btn.tipDirctions = "0";
         this._btn.tipGapV = 5;
         var _loc2_:ItemTemplateInfo = new ItemTemplateInfo();
         _loc2_.Name = LanguageMgr.GetTranslation("tank.game.ToolStripView.itemTemplateInfo.Name");
         _loc2_.Description = LanguageMgr.GetTranslation("tank.game.ToolStripView.itemTemplateInfo.Description");
         var _loc3_:ToolPropInfo = new ToolPropInfo();
         _loc3_.info = _loc2_;
         _loc3_.showPrice = false;
         _loc3_.showThew = false;
         _loc3_.showCount = false;
         this._btn.tipData = _loc3_;
         this._btn2.tipStyle = "core.ToolPropTips";
         this._btn2.tipDirctions = "0";
         this._btn2.tipGapV = 5;
         _loc2_ = new ItemTemplateInfo();
         _loc2_.Name = LanguageMgr.GetTranslation("tank.game.ToolStripView.itemTemplateInfo.Name2");
         _loc2_.Description = LanguageMgr.GetTranslation("tank.game.ToolStripView.itemTemplateInfo.Description2");
         _loc3_ = new ToolPropInfo();
         _loc3_.info = _loc2_;
         _loc3_.showPrice = false;
         _loc3_.showThew = false;
         _loc3_.showCount = false;
         this._btn2.tipData = _loc3_;
         this.setDander();
         this.initEvents();
      }
      
      private function addDanderStripTip() : void
      {
         this._danderStripTip = new ChangeNumToolTip();
         this._danderStripTipInfo = new ChangeNumToolTipInfo();
         this._danderStripTipInfo.currentTxt = ComponentFactory.Instance.creatComponentByStylename("game.DanderStrip.currentTxt");
         this._danderStripTipInfo.title = LanguageMgr.GetTranslation("tank.game.danderStripTip.pow") + ":";
         this._danderStripTipInfo.current = 0;
         this._danderStripTipInfo.total = Player.TOTAL_DANDER / 2;
         this._danderStripTipInfo.content = LanguageMgr.GetTranslation("tank.game.DanderStrip.tip");
         this._danderStripTip.tipData = this._danderStripTipInfo;
         this._danderStripTip.mouseChildren = false;
         this._danderStripTip.mouseEnabled = false;
         this._danderStripTip.x = 640;
         this._danderStripTip.y = 430;
         addChild(this._danderStripTip);
         this._danderStripTip.visible = false;
      }
      
      public function setInfo(param1:LocalPlayer) : void
      {
         this._info = param1;
      }
      
      private function initEvents() : void
      {
         this._danderStripCopy.addEventListener(MouseEvent.MOUSE_OVER,this.__showDanderStripTip);
         this._danderStripCopy.addEventListener(MouseEvent.MOUSE_OUT,this.__hideDanderStripTip);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keydown);
         this._info.addEventListener(LivingEvent.DANDER_CHANGED,this.__update);
         this._info.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__updateBtn);
      }
      
      private function removeEvents() : void
      {
         this._danderStripCopy.removeEventListener(MouseEvent.MOUSE_OVER,this.__showDanderStripTip);
         this._danderStripCopy.removeEventListener(MouseEvent.MOUSE_OUT,this.__hideDanderStripTip);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keydown);
         this._info.removeEventListener(LivingEvent.DANDER_CHANGED,this.__update);
         this._info.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__updateBtn);
         this._skillBtn.removeEventListener(MouseEvent.CLICK,this.__useSkill);
      }
      
      private function __showDanderStripTip(param1:MouseEvent) : void
      {
         this._danderStripTip.visible = true;
         LayerManager.Instance.addToLayer(this._danderStripTip,LayerManager.STAGE_TOP_LAYER,false);
      }
      
      private function __hideDanderStripTip(param1:MouseEvent) : void
      {
         this._danderStripTip.visible = false;
      }
      
      private function __update(param1:LivingEvent) : void
      {
         this.setDander();
      }
      
      private function setDander() : void
      {
         this._danderStripTipInfo.current = this._info.dander / 2;
         this._danderStripTip.tipData = this._danderStripTipInfo;
         var _loc1_:Number = this._info.dander / Player.TOTAL_DANDER;
         TweenLite.killTweensOf(this._mask,true);
         if(_loc1_ > 0)
         {
            TweenLite.to(this._mask,1,{"scaleX":_loc1_});
         }
         else
         {
            this._mask.scaleX = 0;
         }
         this.__updateBtn(null);
      }
      
      private function __updateBtn(param1:LivingEvent) : void
      {
         this._movie.gotoAndStop(this._info.dander >= Player.TOTAL_DANDER ? 2 : 1);
         if(this._info.isAttacking && this._info.dander >= Player.TOTAL_DANDER && !this._isDisable)
         {
            this._skillBtn.buttonMode = true;
            this._skillBtn.addEventListener(MouseEvent.CLICK,this.__useSkill);
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keydown);
         }
         else
         {
            this._skillBtn.buttonMode = false;
            this._skillBtn.removeEventListener(MouseEvent.CLICK,this.__useSkill);
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keydown);
         }
         if(this._isDisable)
         {
            this._movie.gotoAndStop(1);
         }
         this._isDisable = false;
      }
      
      private function __useSkill(param1:MouseEvent) : void
      {
         if(this._specialEnabled && GameManager.Instance.Current.selfGamePlayer.dander >= Player.TOTAL_DANDER && GameManager.Instance.Current.selfGamePlayer.isAttacking)
         {
            GameManager.Instance.Current.selfGamePlayer.skill = 0;
            GameManager.Instance.Current.selfGamePlayer.isSpecialSkill = true;
            GameInSocketOut.sendGameCMDStunt();
            GameManager.Instance.Current.selfGamePlayer.dander = 0;
            SoundManager.instance.play("008");
         }
      }
      
      private function __useSkill2(param1:MouseEvent) : void
      {
         GameManager.Instance.Current.selfGamePlayer.isSpecialSkill = true;
         GameManager.Instance.Current.selfGamePlayer.skill = 1;
         GameInSocketOut.sendGameCMDStunt(1);
         GameManager.Instance.Current.selfGamePlayer.dander = 0;
         SoundManager.instance.play("008");
      }
      
      public function disable() : void
      {
         if(GameManager.Instance.Current.selfGamePlayer.isAttacking)
         {
            this._isDisable = true;
            this.__updateBtn(null);
         }
      }
      
      private function __keydown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == KeyStroke.VK_B.getCode())
         {
            this.__useSkill(null);
         }
         else if(param1.keyCode == KeyStroke.VK_N.getCode())
         {
            this.__useSkill2(null);
         }
      }
      
      public function set specialEnabled(param1:Boolean) : void
      {
         this._specialEnabled = param1;
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      public function set enable(param1:Boolean) : void
      {
         this._enable = param1;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._movie.stop();
         removeChild(this._movie);
         removeChild(this._danderStrip);
         this._danderStrip.bitmapData.dispose();
         this._danderStrip = null;
         removeChild(this._mask);
         this._mask = null;
         this._btn.removeChild(this._skillBtn);
         this._skillBtn = null;
         this._btn.dispose();
         this._btn = null;
         this._info = null;
         this._danderStripTip.dispose();
         this._danderStrip = null;
         this._danderStripTipInfo = null;
         ObjectUtils.disposeAllChildren(this._danderStripCopy);
         removeChild(this._danderStripCopy);
         this._danderStripCopy = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

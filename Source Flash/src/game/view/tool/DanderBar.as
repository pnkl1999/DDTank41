package game.view.tool
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UsePropErrorCode;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.LivingEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.view.tips.ChangeNumToolTip;
   import ddt.view.tips.ChangeNumToolTipInfo;
   import ddt.view.tips.ToolPropInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import game.model.LocalPlayer;
   import game.model.Player;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class DanderBar extends Sprite implements Disposeable, ITipedDisplay
   {
      
      private static const Min:int = 90;
      
      private static const Max:int = -180;
       
      
      private var _back:DisplayObject;
      
      private var _animateBack:Bitmap;
      
      private var _self:LocalPlayer;
      
      private var _maskShape:Shape;
      
      private var _rate:Number;
      
      private var _animate:MovieClip;
      
      private var _btn:SimpleBitmapButton;
      
      private var _skillBtn:Sprite;
      
      private var _tipHitArea:Sprite;
      
      private var _localDander:int;
      
      private var _danderStripTip:ChangeNumToolTip;
      
      private var _danderStripTipInfo:ChangeNumToolTipInfo;
      
      private var _bg:DisplayObject;
      
      private var _localVisible:Boolean = true;
      
      private var _container:DisplayObjectContainer;
      
      private var _specialEnabled:Boolean = true;
      
      public function DanderBar(param1:LocalPlayer, param2:DisplayObjectContainer)
      {
         super();
         this._self = param1;
         this._container = param2;
         buttonMode = true;
         this.configUI();
         this.addEvent();
         this.setDander();
      }
      
      private function addEvent() : void
      {
         this._self.addEventListener(LivingEvent.DANDER_CHANGED,this.__danderChanged);
         this._self.addEventListener(LivingEvent.SPELLKILL_CHANGED,this.__spellKillChanged);
         this._self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
         this._tipHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         this._tipHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
         addEventListener(MouseEvent.CLICK,this.__click);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      private function __attackingChanged(param1:LivingEvent) : void
      {
         buttonMode = this._self.spellKillEnabled && this._self.isAttacking;
      }
      
      private function __keyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == KeyStroke.VK_B.getCode())
         {
            this.useSkill();
         }
      }
      
      private function useSkill() : void
      {
         var _loc1_:String = null;
         if(this._specialEnabled && this._localVisible)
         {
            _loc1_ = this._self.useSpellKill();
            if(_loc1_ == UsePropErrorCode.Done)
            {
               if(NewHandContainer.Instance.hasArrow(ArrowType.TIP_THREE))
               {
                  NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_THREE);
               }
               if(NewHandContainer.Instance.hasArrow(ArrowType.TIP_POWER))
               {
                  NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_POWER);
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("game.view.propContainer.ItemContainer.energy"));
               }
            }
            else if(_loc1_ != UsePropErrorCode.None)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop." + _loc1_));
            }
         }
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
         this._danderStripTip.x = 740;
         this._danderStripTip.y = 430;
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         if(this._danderStripTip.parent)
         {
            this._danderStripTip.parent.removeChild(this._danderStripTip);
         }
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         LayerManager.Instance.addToLayer(this._danderStripTip,LayerManager.STAGE_TOP_LAYER,false);
      }
      
      private function removeEvent() : void
      {
         this._self.removeEventListener(LivingEvent.DANDER_CHANGED,this.__danderChanged);
         this._self.removeEventListener(LivingEvent.SPELLKILL_CHANGED,this.__spellKillChanged);
         this._self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
         this._tipHitArea.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         this._tipHitArea.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
         removeEventListener(MouseEvent.CLICK,this.__click);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      private function __spellKillChanged(param1:LivingEvent) : void
      {
         if(this._self.spellKillEnabled)
         {
            this._animate.visible = true;
            this._animate.gotoAndPlay(1);
         }
         else
         {
            this._animate.visible = false;
            this._animate.gotoAndStop(1);
         }
      }
      
      private function __click(param1:MouseEvent) : void
      {
         this.useSkill();
      }
      
      private function __danderChanged(param1:LivingEvent) : void
      {
         this.setDander();
      }
      
      private function setDander() : void
      {
         this._danderStripTipInfo.current = this._self.dander / 2;
         this._danderStripTip.tipData = this._danderStripTipInfo;
         TweenLite.killTweensOf(this);
         TweenLite.to(this,0.3,{"localDander":this._self.dander});
         if(this._self.dander >= Player.TOTAL_DANDER)
         {
            if(this._self.spellKillEnabled)
            {
               this._animate.visible = true;
               this._animate.gotoAndPlay(1);
               buttonMode = true;
            }
         }
         else
         {
            this._animate.visible = false;
            this._animate.gotoAndStop(1);
            buttonMode = false;
         }
      }
      
      private function drawProgress(param1:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc2_:int = Min - Math.abs(Max - Min) * param1;
         var _loc3_:Graphics = this._maskShape.graphics;
         _loc3_.clear();
         _loc3_.beginFill(0,1);
         _loc3_.moveTo(0,0);
         _loc3_.lineTo(0,52);
         var _loc5_:int = Min;
         while(_loc5_ >= _loc2_)
         {
            _loc6_ = 52 * Math.cos(_loc5_ / 180 * Math.PI);
            _loc7_ = 52 * Math.sin(_loc5_ / 180 * Math.PI);
            _loc3_.lineTo(_loc6_,_loc7_);
            _loc5_--;
         }
         _loc3_.lineTo(0,0);
      }
      
      private function configUI() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Graphics = null;
         _loc2_ = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.dander.bg");
         addChild(this._bg);
         this._back = ComponentFactory.Instance.creat("asset.game.dander.back");
         this._back.x = this._back.y = -1;
         addChild(this._back);
         _loc2_ = 52;
         this._tipHitArea = new Sprite();
         _loc1_ = this._tipHitArea.graphics;
         _loc1_.clear();
         _loc1_.beginFill(0,0);
         _loc1_.moveTo(0,0);
         _loc1_.lineTo(0,_loc2_);
         _loc3_ = Min;
         while(_loc3_ >= Max)
         {
            _loc4_ = _loc2_ * Math.cos(_loc3_ / 180 * Math.PI);
            _loc5_ = _loc2_ * Math.sin(_loc3_ / 180 * Math.PI);
            _loc1_.lineTo(_loc4_,_loc5_);
            _loc3_--;
         }
         _loc1_.lineTo(0,0);
         this._tipHitArea.x = _loc2_;
         this._tipHitArea.y = _loc2_;
         addChild(this._tipHitArea);
         this._maskShape = new Shape();
         _loc1_ = this._maskShape.graphics;
         _loc1_.clear();
         _loc1_.beginFill(0,1);
         _loc1_.moveTo(0,0);
         _loc1_.lineTo(0,_loc2_);
         _loc3_ = Min;
         while(_loc3_ >= Min)
         {
            _loc4_ = _loc2_ * Math.cos(_loc3_ / 180 * Math.PI);
            _loc5_ = _loc2_ * Math.sin(_loc3_ / 180 * Math.PI);
            _loc1_.lineTo(_loc4_,_loc5_);
            _loc3_--;
         }
         _loc1_.lineTo(0,0);
         this._maskShape.x = _loc2_;
         this._maskShape.y = _loc2_;
         addChild(this._maskShape);
         this._back.mask = this._maskShape;
         this._animateBack = ComponentFactory.Instance.creatBitmap("asset.game.dander.animate.back");
         addChild(this._animateBack);
         this._animate = ComponentFactory.Instance.creat("asset.game.dande.animate");
         this._animate.mouseChildren = this._animate.mouseEnabled = false;
         this._animate.visible = false;
         this._animate.gotoAndStop(1);
         this._animate.x = 34;
         this._animate.y = 33;
         this._animate.scaleX = this._animate.scaleY = 0.8;
         addChild(this._animate);
         this._btn = new SimpleBitmapButton();
         addChild(this._btn);
         this._btn.x = 39;
         this._btn.y = 40;
         this._btn.mouseChildren = true;
         this._btn.buttonMode = false;
         this._skillBtn = new Sprite();
         this._skillBtn.graphics.beginFill(16777215,0);
         this._skillBtn.graphics.drawCircle(0,0,22);
         this._skillBtn.graphics.endFill();
         this._btn.addChild(this._skillBtn);
         this._btn.tipStyle = "core.ToolPropTips";
         this._btn.tipDirctions = "4";
         this._btn.tipGapV = 30;
         this._btn.tipGapH = 30;
         var _loc6_:ItemTemplateInfo = new ItemTemplateInfo();
         _loc6_.Name = LanguageMgr.GetTranslation("tank.game.ToolStripView.itemTemplateInfo.Name");
         _loc6_.Description = LanguageMgr.GetTranslation("tank.game.ToolStripView.itemTemplateInfo.Description");
         var _loc7_:ToolPropInfo = new ToolPropInfo();
         _loc7_.info = _loc6_;
         _loc7_.showPrice = false;
         _loc7_.showThew = false;
         _loc7_.showCount = false;
         this._btn.tipData = _loc7_;
         this.addDanderStripTip();
      }
      
      public function set localDander(param1:int) : void
      {
         this._localDander = param1;
         this.drawProgress(this._localDander / Player.TOTAL_DANDER);
      }
      
      public function get localDander() : int
      {
         return this._localDander;
      }
      
      public function setVisible(param1:Boolean) : void
      {
         if(this._localVisible != param1)
         {
            this._localVisible = param1;
            if(this._localVisible)
            {
               this._container.addChild(this);
            }
            else if(parent)
            {
               parent.removeChild(this);
            }
         }
      }
      
      public function set specialEnabled(param1:Boolean) : void
      {
         if(this._specialEnabled != param1)
         {
            this._specialEnabled = param1;
            if(!this._specialEnabled)
            {
            }
            mouseEnabled = this._specialEnabled;
         }
      }
      
      public function dispose() : void
      {
         TweenLite.killTweensOf(this);
         this.removeEvent();
         this._self = null;
         this._danderStripTipInfo = null;
         this._back = null;
         this._maskShape = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         if(this._back)
         {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
         }
         if(this._tipHitArea)
         {
            ObjectUtils.disposeObject(this._tipHitArea);
            this._tipHitArea = null;
         }
         if(this._animate)
         {
            this._animate.gotoAndStop(1);
            ObjectUtils.disposeObject(this._animate);
            this._animate = null;
         }
         this._btn = null;
         this._skillBtn = null;
         if(this._danderStripTip)
         {
            ObjectUtils.disposeObject(this._danderStripTip);
            this._danderStripTip = null;
         }
         if(this._animateBack)
         {
            ObjectUtils.disposeObject(this._animateBack);
            this._animateBack = null;
         }
         ObjectUtils.disposeAllChildren(this);
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get tipData() : Object
      {
         return null;
      }
      
      public function set tipData(param1:Object) : void
      {
      }
      
      public function get tipDirctions() : String
      {
         return null;
      }
      
      public function set tipDirctions(param1:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return 0;
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 0;
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         return null;
      }
      
      public function set tipStyle(param1:String) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return null;
      }
   }
}

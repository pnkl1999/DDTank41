package game.view.arrow
{
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.FightLibManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.GraphicsUtils;
   import ddt.view.common.GradientText;
   import ddt.view.tips.ToolPropInfo;
   import fightLib.LessonType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   import game.model.LocalPlayer;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import room.RoomManager;
   import room.model.WeaponInfo;
   import trainer.data.Step;
   
   public class ArrowView extends Sprite implements Disposeable
   {
      
      public static const FLY_CD:int = 2;
      
      public static const HIDE_BAR:String = "hide bar";
      
      public static const USE_TOOL:String = "use_tool";
      
      public static const ADD_BLOOD_CD:int = 2;
      
      public static const RANDOW_COLORSII:Array = [[1351165,16768512],[1478655,2607344],[1555258,14293039],[7912215,14293199],[12862218,7721224],[14577152,15970051],[6011902,832292],[521814,13411850],[15035908,11327256],[15118867,8369930],[2213785,8116729],[10735137,14497882],[15460371,15430666],[13032456,2861311],[16670299,12510266],[44799,7721224]];
      
      public static const ANGLE_NEXTCHANGE_TIME:int = 100;
       
      
      private var _bg:ArrowBg;
      
      private var _info:LocalPlayer;
      
      private var _sector:Sprite;
      
      private var _recordChangeBefore:Number;
      
      private var _flyCoolDown:int = 0;
      
      private var _flyEnable:Boolean;
      
      private var _isLockFly:Boolean = false;
      
      private var rotationCountField:GradientText;
      
      private var _hammerCoolDown:int = 0;
      
      private var _hammerEnable:Boolean;
      
      private var _deputyWeaponResCount:int;
      
      private var _AngelLine:MovieClip;
      
      private var _ShineKey:Boolean;
      
      public var _AnglelShineEffect:IEffect;
      
      private var _hideState:Boolean;
      
      private var _enableArrow:Boolean;
      
      private var _currentAngleChangeTime:int = 0;
      
      private var _first:Boolean = true;
      
      private var _recordRotation:Number;
      
      private var _hammerBlocked:Boolean;
      
      public function ArrowView(param1:LocalPlayer)
      {
         var _loc3_:Point = null;
         _loc3_ = null;
         super();
         this._info = param1;
         this._bg = ComponentFactory.Instance.creatCustomObject("game.view.arrowBg") as ArrowBg;
         addChild(this._bg);
         this._bg.arrowSub.arrowClone_mc.visible = false;
         this._bg.arrowSub.arrowChonghe_mc.visible = false;
         this._sector = GraphicsUtils.drawSector(0,0,55,0,90);
         this._sector.y = 1;
         this._bg.arrowSub.circle_mc.mask = this._sector;
         this._bg.arrowSub.circle_mc.visible = true;
         this._bg.arrowSub.green_mc.visible = false;
         this._bg.arrowSub.addChild(this._sector);
         var _loc2_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("asset.game.rotationCountFieldText");
         this.rotationCountField = new GradientText(_loc2_,RANDOW_COLORSII);
         _loc3_ = ComponentFactory.Instance.creatCustomObject("asset.game.rotationCountPos");
         this.rotationCountField.x = _loc3_.x;
         this.rotationCountField.y = _loc3_.y;
         addChild(this.rotationCountField);
         this.rotationCountField.filters = ComponentFactory.Instance.creatFilters("game.rotationCountField_Filter");
         this.rotationCountField.setText(this.rotationCountField.text);
         this.reset();
         this.__weapAngle(null);
         this.__changeDirection(null);
         this.flyEnable = true;
         this.hammerEnable = true;
         this._flyCoolDown = 0;
         this._hammerCoolDown = 0;
         if(this._info.selfInfo && this._info.selfInfo.DeputyWeapon)
         {
            this._deputyWeaponResCount = this._info.selfInfo.DeputyWeapon.StrengthenLevel + 1;
         }
         this.updataAngleLine();
      }
      
      public function set flyEnable(param1:Boolean) : void
      {
         if(param1 == this._flyEnable)
         {
            return;
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_OPEN))
         {
            param1 = false;
         }
         this._flyEnable = param1;
         if(this._isLockFly)
         {
            this._info.flyEnabled = false;
         }
         else
         {
            this._info.flyEnabled = this._flyEnable;
         }
      }
      
      private function __sendShootAction(param1:LivingEvent) : void
      {
         var _loc2_:LocalPlayer = param1.currentTarget as LocalPlayer;
         if(_loc2_.currentBomb == 3)
         {
            this._info.removeEventListener(LivingEvent.SEND_SHOOT_ACTION,this.__sendShootAction);
            SocketManager.Instance.out.syncWeakStep(Step.GUIDE_PLANE);
         }
      }
      
      public function set hammerEnable(param1:Boolean) : void
      {
         if(param1 == this._hammerEnable)
         {
            return;
         }
         if(!this._info.hasDeputyWeapon())
         {
            this._hammerEnable = false;
         }
         else
         {
            this._hammerEnable = param1;
         }
         this._info.deputyWeaponEnabled = this._hammerEnable;
      }
      
      public function get hammerEnable() : Boolean
      {
         return this._hammerEnable;
      }
      
      public function disable() : void
      {
         this.flyEnable = false;
         if(!this._info.currentDeputyWeaponInfo.isShield)
         {
            this.hammerEnable = false;
         }
      }
      
      private function updataAngleLine() : void
      {
         if(RoomManager.Instance.current.gameMode == 8)
         {
            this.showAngleLine(FightLibManager.Instance.currentInfo.id);
         }
      }
      
      private function showAngleLine(param1:int) : void
      {
         if(!this._AngelLine)
         {
            this._AngelLine = ComponentFactory.Instance.creatCustomObject("game.fightLib.AngleStyle");
            addChild(this._AngelLine);
            this._AngelLine.gotoAndStop("stand");
         }
         switch(param1)
         {
            case LessonType.Twenty:
               this._AngelLine.gotoAndStop("20Degree");
               break;
            case LessonType.SixtyFive:
               this._AngelLine.gotoAndStop("65Degree");
               break;
            case LessonType.HighThrow:
               this._AngelLine.gotoAndStop("90Degree");
               break;
            default:
               return;
         }
         this._AnglelShineEffect = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._AngelLine,{"color":EffectColorType.GOLD});
      }
      
      private function setTip(param1:BaseButton, param2:String, param3:String, param4:String, param5:String = "0", param6:Boolean = true, param7:int = 10) : void
      {
         param1.tipStyle = "core.ToolPropTips";
         param1.tipDirctions = param5;
         param1.tipGapV = 0;
         param1.tipGapH = param7;
         var _loc8_:ItemTemplateInfo = new ItemTemplateInfo();
         _loc8_.Name = param2;
         _loc8_.Property4 = param3;
         _loc8_.Description = param4;
         var _loc9_:ToolPropInfo = new ToolPropInfo();
         _loc9_.info = _loc8_;
         _loc9_.count = 1;
         _loc9_.showPrice = false;
         _loc9_.showThew = param6;
         _loc9_.showCount = false;
         param1.tipData = _loc9_;
      }
      
      private function reset() : void
      {
         this._bg.arrowSub.green_mc.mask = null;
         this._bg.arrowSub.circle_mc.mask = this._sector;
         this._bg.arrowSub.circle_mc.visible = true;
         this._bg.arrowSub.green_mc.visible = false;
         if(this._info && this._info.currentWeapInfo)
         {
            GraphicsUtils.changeSectorAngle(this._sector,0,0,55,this._info.currentWeapInfo.armMinAngle,this._info.currentWeapInfo.armMaxAngle - this._info.currentWeapInfo.armMinAngle + 1);
         }
      }
      
      public function set hideState(param1:Boolean) : void
      {
         this._hideState = param1;
      }
      
      public function get hideState() : Boolean
      {
         return this._hideState;
      }
      
      private function carrayAngle() : void
      {
         this._bg.arrowSub.circle_mc.mask = null;
         this._bg.arrowSub.green_mc.mask = this._sector;
         this._bg.arrowSub.circle_mc.visible = false;
         this._bg.arrowSub.green_mc.visible = true;
         GraphicsUtils.changeSectorAngle(this._sector,0,0,55,0,90);
      }
      
      public function dispose() : void
      {
         if(this._AnglelShineEffect)
         {
            EffectManager.Instance.removeEffect(this._AnglelShineEffect);
         }
         FightLibManager.Instance.isWork = false;
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         ObjectUtils.disposeObject(this._sector);
         ObjectUtils.disposeObject(this.rotationCountField);
         ObjectUtils.disposeObject(this._AngelLine);
         this._bg = null;
         this._info = null;
         this._sector = null;
         this.rotationCountField = null;
         this._AngelLine = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function initEvents() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_PLANE) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_OPEN))
         {
            this._info.addEventListener(LivingEvent.SEND_SHOOT_ACTION,this.__sendShootAction);
         }
         this._info.addEventListener(LivingEvent.GUNANGLE_CHANGED,this.__weapAngle);
         this._info.addEventListener(LivingEvent.DIR_CHANGED,this.__changeDirection);
         this._info.addEventListener(LivingEvent.ANGLE_CHANGED,this.__changeAngle);
         this._info.addEventListener(LivingEvent.BOMB_CHANGED,this.__changeBall);
         this._info.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__setArrowClone);
         this._info.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__change);
         this._info.addEventListener(LivingEvent.BEGIN_NEW_TURN,this.__onTurnChange);
         this._info.addEventListener(LivingEvent.DIE,this.__die);
         this._info.addEventListener(LivingEvent.LOCKANGLE_CHANGE,this.__lockAngleChangeHandler);
         addEventListener(Event.ENTER_FRAME,this.__enterFrame);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keydown);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__inputKeyDown);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_DEPUTY_WEAPON,this.__setDeputyWeaponNumber);
      }
      
      private function removeEvent() : void
      {
         this._info.removeEventListener(LivingEvent.SEND_SHOOT_ACTION,this.__sendShootAction);
         this._info.removeEventListener(LivingEvent.GUNANGLE_CHANGED,this.__weapAngle);
         this._info.removeEventListener(LivingEvent.DIR_CHANGED,this.__changeDirection);
         this._info.removeEventListener(LivingEvent.ANGLE_CHANGED,this.__changeAngle);
         this._info.removeEventListener(LivingEvent.BOMB_CHANGED,this.__changeBall);
         this._info.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__setArrowClone);
         this._info.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__change);
         this._info.removeEventListener(LivingEvent.DIE,this.__die);
         this._info.removeEventListener(LivingEvent.BEGIN_NEW_TURN,this.__onTurnChange);
         this._info.removeEventListener(LivingEvent.LOCKANGLE_CHANGE,this.__lockAngleChangeHandler);
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keydown);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__inputKeyDown);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_DEPUTY_WEAPON,this.__setDeputyWeaponNumber);
      }
      
      private function __lockAngleChangeHandler(param1:LivingEvent) : void
      {
         this.enableArrow = this._info.isLockAngle;
      }
      
      public function set enableArrow(param1:Boolean) : void
      {
         this._enableArrow = param1;
         if(!param1)
         {
            addEventListener(Event.ENTER_FRAME,this.__enterFrame);
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__inputKeyDown);
         }
         else
         {
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__inputKeyDown);
            removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         }
      }
      
      private function __onTurnChange(param1:LivingEvent) : void
      {
         this.rotationCountField.setText(this.rotationCountField.text);
      }
      
      private function __die(param1:Event) : void
      {
         if(!this._info.isLiving)
         {
            this.flyEnable = false;
            this.hammerEnable = false;
         }
      }
      
      private function __enterFrame(param1:Event) : void
      {
         var _loc4_:Boolean = false;
         var _loc2_:int = getTimer();
         if(_loc2_ - this._currentAngleChangeTime < ANGLE_NEXTCHANGE_TIME)
         {
            return;
         }
         var _loc3_:Boolean = false;
         if(KeyboardManager.isDown(KeyStroke.VK_S.getCode()) || KeyboardManager.isDown(Keyboard.DOWN))
         {
            if(this._currentAngleChangeTime != 0)
            {
               _loc3_ = this._info.manuallySetGunAngle(this._info.gunAngle - WeaponInfo.ROTATITON_SPEED * this._info.reverse);
            }
            else
            {
               this._currentAngleChangeTime = getTimer();
            }
            _loc4_ = true;
         }
         else if(KeyboardManager.isDown(KeyStroke.VK_W.getCode()) || KeyboardManager.isDown(Keyboard.UP))
         {
            if(this._currentAngleChangeTime != 0)
            {
               _loc3_ = this._info.manuallySetGunAngle(this._info.gunAngle + WeaponInfo.ROTATITON_SPEED * this._info.reverse);
            }
            if(this._currentAngleChangeTime == 0)
            {
               this._currentAngleChangeTime = getTimer();
            }
            _loc4_ = true;
         }
         if(!_loc4_)
         {
            this._currentAngleChangeTime = 0;
         }
         if(_loc3_)
         {
            SoundManager.instance.play("006");
         }
      }
      
      private function __inputKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:Boolean = false;
         if(!ChatManager.Instance.input.inputField.isFocus())
         {
            _loc2_ = false;
            if(param1.keyCode == KeyStroke.VK_S.getCode() || param1.keyCode == Keyboard.DOWN)
            {
               _loc2_ = this._info.manuallySetGunAngle(this._info.gunAngle - WeaponInfo.ROTATITON_SPEED * this._info.reverse);
               this._currentAngleChangeTime = 0;
            }
            else if(param1.keyCode == KeyStroke.VK_W.getCode() || param1.keyCode == Keyboard.UP)
            {
               _loc2_ = this._info.manuallySetGunAngle(this._info.gunAngle + WeaponInfo.ROTATITON_SPEED * this._info.reverse);
               this._currentAngleChangeTime = 0;
            }
            if(_loc2_)
            {
               SoundManager.instance.play("006");
            }
         }
      }
      
      private function __keydown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode != KeyStroke.VK_F.getCode())
         {
            if(param1.keyCode == KeyStroke.VK_T.getCode())
            {
               dispatchEvent(new Event(ArrowView.HIDE_BAR));
            }
            else if(param1.keyCode == KeyStroke.VK_R.getCode())
            {
            }
         }
      }
      
      private function __changeBall(param1:LivingEvent) : void
      {
         if(this._info.currentBomb == 3)
         {
            this.carrayAngle();
         }
         else
         {
            this.resetAngle();
         }
      }
      
      private function resetAngle() : void
      {
         this.reset();
      }
      
      private function __change(param1:LivingEvent) : void
      {
         if(this._info == null)
         {
            return;
         }
         var _loc2_:Number = Number(this._info.currentDeputyWeaponInfo.energy);
         this.resetAngle();
      }
      
      private function __weapAngle(param1:LivingEvent) : void
      {
         if(RoomManager.Instance.current.gameMode == 8)
         {
            this.checkAngle();
         }
         var _loc2_:Number = 0;
         if(this._info.direction == -1)
         {
            _loc2_ = 0;
         }
         else
         {
            _loc2_ = 180;
         }
         if(this._info.gunAngle < 0)
         {
            this._bg.arrowSub.arrow.rotation = 360 - (this._info.gunAngle - 180 + _loc2_) * this._info.direction;
         }
         else
         {
            this._bg.arrowSub.arrow.rotation = 360 - (this._info.gunAngle + 180 + _loc2_) * this._info.direction;
         }
         this._recordChangeBefore = this._info.gunAngle;
         this.rotationCountField.setText(String(this._info.gunAngle + this._info.playerAngle * -1 * this._info.direction),false);
         if(this._bg.arrowSub.arrow.rotation == this._bg.arrowSub.arrowClone_mc.rotation)
         {
            this._bg.arrowSub.arrowChonghe_mc.visible = true;
            this._bg.arrowSub.arrowChonghe_mc.rotation = this._bg.arrowSub.arrow.rotation;
            this._bg.arrowSub.arrowClone_mc.visible = false;
            this._bg.arrowSub.arrow.visible = false;
         }
         else
         {
            this._bg.arrowSub.arrowChonghe_mc.visible = false;
            this._bg.arrowSub.arrowClone_mc.visible = !!this._first ? Boolean(Boolean(false)) : Boolean(Boolean(true));
            this._bg.arrowSub.arrow.visible = true;
         }
      }
      
      private function checkAngle() : void
      {
         if(this._info.direction !== 1 || !this._AnglelShineEffect)
         {
            return;
         }
         var _loc1_:int = this._info.gunAngle + this._info.playerAngle * -1 * this._info.direction;
         if(FightLibManager.Instance.currentInfo)
         {
            switch(FightLibManager.Instance.currentInfo.id)
            {
               case LessonType.Twenty:
                  if(_loc1_ > 30 || _loc1_ < 10)
                  {
                     this.ShineKey = true;
                  }
                  else
                  {
                     this.ShineKey = false;
                  }
                  break;
               case LessonType.SixtyFive:
                  if(_loc1_ > 75 || _loc1_ < 55)
                  {
                     this.ShineKey = true;
                  }
                  else
                  {
                     this.ShineKey = false;
                  }
                  break;
               case LessonType.HighThrow:
                  if(_loc1_ > 100 || _loc1_ < 60)
                  {
                     this.ShineKey = true;
                  }
                  else
                  {
                     this.ShineKey = false;
                  }
            }
         }
      }
      
      public function set ShineKey(param1:Boolean) : void
      {
         if(this._ShineKey == param1)
         {
            return;
         }
         this._ShineKey = param1;
         this.shineAngleLine();
      }
      
      public function get ShineKey() : Boolean
      {
         return this._ShineKey;
      }
      
      private function shineAngleLine() : void
      {
         if(this._ShineKey == true)
         {
            FightLibManager.Instance.isWork = true;
            this._AnglelShineEffect.play();
         }
         else
         {
            FightLibManager.Instance.isWork = false;
            this._AnglelShineEffect.stop();
         }
      }
      
      private function __changeDirection(param1:LivingEvent) : void
      {
         this.__weapAngle(null);
         if(this._info.direction == -1)
         {
            this._sector.scaleX = -1;
            if(this._AnglelShineEffect)
            {
               this.ShineKey = true;
            }
         }
         else
         {
            this._sector.scaleX = 1;
         }
      }
      
      private function __changeAngle(param1:LivingEvent) : void
      {
         if(RoomManager.Instance.current.gameMode == 8)
         {
            this.checkAngle();
         }
         var _loc2_:Number = this._bg.arrowSub.rotation - this._info.playerAngle;
         this._bg.arrowSub.rotation = this._info.playerAngle;
         this._recordRotation += _loc2_;
         this._bg.arrowSub.arrowClone_mc.rotation = this._recordRotation;
         this.rotationCountField.setText(String(this._info.gunAngle + this._info.playerAngle * -1 * this._info.direction),false);
         if(this._bg.arrowSub.arrow.rotation == this._bg.arrowSub.arrowClone_mc.rotation)
         {
            this._bg.arrowSub.arrowChonghe_mc.visible = true;
            this._bg.arrowSub.arrowChonghe_mc.rotation = this._bg.arrowSub.arrow.rotation;
            this._bg.arrowSub.arrowClone_mc.visible = false;
            this._bg.arrowSub.arrow.visible = false;
         }
         else
         {
            this._bg.arrowSub.arrowChonghe_mc.visible = false;
            this._bg.arrowSub.arrowClone_mc.visible = !!this._first ? Boolean(Boolean(false)) : Boolean(Boolean(true));
            this._bg.arrowSub.arrow.visible = true;
         }
      }
      
      private function __setArrowClone(param1:Event) : void
      {
         if(!this._info.isAttacking)
         {
            this._first = false;
            this._bg.arrowSub.arrowClone_mc.visible = true;
            this._recordRotation = this._bg.arrowSub.arrow.rotation;
            this._bg.arrowSub.arrowClone_mc.rotation = this._bg.arrowSub.arrow.rotation;
         }
      }
      
      public function setRecordRotation() : void
      {
         this._first = false;
         this._bg.arrowSub.arrowClone_mc.visible = true;
         this._recordRotation = this._bg.arrowSub.arrow.rotation;
         this._bg.arrowSub.arrowClone_mc.rotation = this._bg.arrowSub.arrow.rotation;
      }
      
      public function blockHammer() : void
      {
         this._hammerBlocked = true;
         this._hammerCoolDown = 100000;
      }
      
      public function allowHammer() : void
      {
         this._hammerBlocked = false;
         this._hammerCoolDown = 0;
      }
      
      private function __setDeputyWeaponNumber(param1:CrazyTankSocketEvent) : void
      {
         this._deputyWeaponResCount = param1.pkg.readInt();
         this._info.deputyWeaponCount = this._deputyWeaponResCount;
      }
      
      public function get transparentBtn() : SimpleBitmapButton
      {
         return null;
      }
      
      public function setPlaneBtnVisible(param1:Boolean) : void
      {
         this.flyEnable = param1;
      }
      
      public function setOffHandedBtnVisible(param1:Boolean) : void
      {
         this.hammerEnable = param1;
      }
      
      public function enter() : void
      {
         this.initEvents();
         this.__changeAngle(null);
      }
      
      public function leaving() : void
      {
         this.removeEvent();
      }
   }
}

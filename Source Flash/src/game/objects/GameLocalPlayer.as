package game.objects
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.LivingEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.SoundManager;
   import ddt.view.character.GameCharacter;
   import ddt.view.character.ShowCharacter;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import game.actions.FocusInLivingAction;
   import game.actions.PlayerBeatAction;
   import game.actions.SelfPlayerWalkAction;
   import game.actions.SelfSkipAction;
   import game.actions.newHand.NewHandFightHelpAction;
   import game.actions.newHand.NewHandFightHelpIIAction;
   import game.animations.AnimationLevel;
   import game.animations.BaseSetCenterAnimation;
   import game.animations.DragMapAnimation;
   import game.model.LocalPlayer;
   import game.model.Player;
   import game.view.map.MapView;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import pet.date.PetSkillTemplateInfo;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class GameLocalPlayer extends GamePlayer
   {
      
      private static const MAX_MOVE_TIME:int = 10;
       
      
      private var _takeAim:MovieClip;
      
      private var _moveStripContainer:Sprite;
      
      private var _moveStrip:Bitmap;
      
      private var _ballpos:Point;
      
      protected var _shootTimer:Timer;
      
      private var mouseAsset:MovieClip;
      
      private var _turned:Boolean;
      
      private var _keyDownTime:int;
      
      private var _transmissionEffoct:MovieClip;
      
      protected var _isShooting:Boolean = false;
      
      protected var _shootCount:int = 0;
      
      protected var _shootPoint:Point;
      
      private var _shootOverCount:int = 0;
      
      public function GameLocalPlayer(param1:LocalPlayer, param2:ShowCharacter, param3:GameCharacter = null)
      {
         super(param1,param2,param3);
      }
      
      public function get localPlayer() : LocalPlayer
      {
         return info as LocalPlayer;
      }
      
      public function get aim() : MovieClip
      {
         return this._takeAim;
      }
      
      override public function set pos(param1:Point) : void
      {
         if(param1.x < 1000)
         {
         }
         x = param1.x;
         y = param1.y;
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._ballpos = new Point(30,-20);
         this._takeAim = ClassUtils.CreatInstance("asset.game.TakeAimAsset");
         this._takeAim.x = this._ballpos.x * -1;
         this._takeAim.y = this._ballpos.y;
         this._takeAim["hand"].rotation = this.localPlayer.currentWeapInfo.armMinAngle;
         this._takeAim.mouseChildren = this._takeAim.mouseEnabled = false;
         this._moveStripContainer = new Sprite();
         this._moveStripContainer.addChild(ComponentFactory.Instance.creatBitmap("asset.game.moveStripBgAsset"));
         this._moveStrip = ComponentFactory.Instance.creatBitmap("asset.game.moveStripAsset");
         this._moveStripContainer.addChild(this._moveStrip);
         this._moveStripContainer.mouseChildren = this._moveStripContainer.mouseEnabled = false;
         if(_consortiaName)
         {
            this._moveStripContainer.x = 0;
            this._moveStripContainer.y = _consortiaName.y + 22;
         }
         else
         {
            this._moveStripContainer.x = 0;
            this._moveStripContainer.y = _nickName.y + 22;
         }
         this.localPlayer.energy = this.localPlayer.maxEnergy;
         this.mouseAsset = ClassUtils.CreatInstance("asset.game.MouseShape") as MovieClip;
         this.mouseAsset.visible = false;
         this._shootTimer = new Timer(Player.SHOOT_TIMER);
      }
      
      override protected function initListener() : void
      {
         super.initListener();
         this.localPlayer.addEventListener(LivingEvent.SEND_SHOOT_ACTION,this.__sendShoot);
         this.localPlayer.addEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChanged);
         this.localPlayer.addEventListener(LivingEvent.GUNANGLE_CHANGED,this.__gunangleChanged);
         this.localPlayer.addEventListener(LivingEvent.SKIP,this.__skip);
         this.localPlayer.addEventListener(LivingEvent.SETCENTER,this.__setCenter);
         this._shootTimer.addEventListener(TimerEvent.TIMER,this.__shootTimer);
         KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_LEFT,this.__turnLeft);
         KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_A,this.__turnLeft);
         KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_RIGHT,this.__turnRight);
         KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_D,this.__turnRight);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_UP,this.__keyUp);
      }
      
      private function __setCenter(param1:LivingEvent) : void
      {
         var _loc2_:Array = param1.paras;
         map.animateSet.addAnimation(new DragMapAnimation(_loc2_[0],_loc2_[1],true));
      }
      
      override public function dispose() : void
      {
         this._shootTimer.removeEventListener(TimerEvent.TIMER,this.__shootTimer);
         this.localPlayer.removeEventListener(LivingEvent.SEND_SHOOT_ACTION,this.__sendShoot);
         this.localPlayer.removeEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChanged);
         this.localPlayer.removeEventListener(LivingEvent.GUNANGLE_CHANGED,this.__gunangleChanged);
         this.localPlayer.removeEventListener(LivingEvent.SKIP,this.__skip);
         this.localPlayer.removeEventListener(LivingEvent.SETCENTER,this.__setCenter);
         KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_LEFT,this.__turnLeft);
         KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_A,this.__turnLeft);
         KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_RIGHT,this.__turnRight);
         KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_D,this.__turnRight);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_UP,this.__keyUp);
         _map.removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         if(this._takeAim && this._takeAim.parent)
         {
            this._takeAim.parent.removeChild(this._takeAim);
         }
         this._takeAim.stop();
         this._takeAim = null;
         this._moveStripContainer.removeChild(this._moveStrip);
         this._moveStrip.bitmapData.dispose();
         this._moveStrip = null;
         if(this._moveStripContainer && this._moveStripContainer.parent)
         {
            this._moveStripContainer.parent.removeChild(this._moveStripContainer);
         }
         this._moveStripContainer = null;
         this._shootTimer.stop();
         this._shootTimer = null;
         this.mouseAsset.stop();
         if(this.mouseAsset.parent)
         {
            this.mouseAsset.parent.removeChild(this.mouseAsset);
         }
         this.mouseAsset = null;
         super.dispose();
      }
      
      protected function __skip(param1:LivingEvent) : void
      {
         act(new SelfSkipAction(this.localPlayer));
      }
      
      private function __keyUp(param1:KeyboardEvent) : void
      {
         this._keyDownTime = 0;
      }
      
      private function __turnLeft() : void
      {
         if(!this._isShooting)
         {
            if(info.direction == 1)
            {
               info.direction = -1;
               if(this._keyDownTime == 0)
               {
                  this._keyDownTime = getTimer();
               }
            }
            this.walk();
         }
      }
      
      private function __turnRight() : void
      {
         if(!this._isShooting)
         {
            if(info.direction == -1)
            {
               info.direction = 1;
               if(this._keyDownTime == 0)
               {
                  this._keyDownTime = getTimer();
               }
            }
            this.walk();
         }
      }
      
      protected function walk() : void
      {
         if(!_isMoving && this.localPlayer.isAttacking && (this._keyDownTime == 0 || getTimer() - this._keyDownTime > MAX_MOVE_TIME))
         {
            act(new SelfPlayerWalkAction(this));
         }
      }
      
      public function showTransmissionEffoct() : void
      {
         if(this._transmissionEffoct)
         {
            ObjectUtils.disposeObject(this._transmissionEffoct);
            this._transmissionEffoct = null;
         }
         if(_player)
         {
            _player.visible = false;
         }
         if(_nickName)
         {
            _nickName.visible = false;
         }
         if(_bloodStripBg)
         {
            _bloodStripBg.visible = false;
         }
         if(_HPStrip)
         {
            _HPStrip.visible = false;
         }
         if(_consortiaName)
         {
            _consortiaName.visible = false;
         }
         if(_buffBar)
         {
            _buffBar.visible = false;
         }
         this._transmissionEffoct = ClassUtils.CreatInstance("asset.game.transmittedEffoct");
         this._transmissionEffoct.x = _player.x;
         this._transmissionEffoct.y = _player.y;
         this._transmissionEffoct.play();
         addChild(this._transmissionEffoct);
      }
      
      override public function startMoving() : void
      {
         _isMoving = true;
      }
      
      override public function stopMoving() : void
      {
         _vx.clearMotion();
         _vy.clearMotion();
         _isMoving = false;
      }
      
      override protected function __attackingChanged(param1:LivingEvent) : void
      {
         super.__attackingChanged(param1);
         if(this.localPlayer.isAttacking && this.localPlayer.isLiving)
         {
            act(new SelfPlayerWalkAction(this));
         }
         this.localPlayer.clearPropArr();
      }
      
      override protected function attackingViewChanged() : void
      {
         super.attackingViewChanged();
         if(this.localPlayer.isAttacking && this.localPlayer.isLiving)
         {
            _player.addChild(this._takeAim);
            addChild(this._moveStripContainer);
         }
         else
         {
            if(_player.contains(this._takeAim))
            {
               _player.removeChild(this._takeAim);
            }
            if(this._moveStripContainer.parent)
            {
               removeChild(this._moveStripContainer);
            }
         }
      }
      
      override public function die() : void
      {
         this.localPlayer.dander = 0;
         if(_player.contains(this._takeAim))
         {
            _player.removeChild(this._takeAim);
         }
         if(this._moveStripContainer && this._moveStripContainer.parent)
         {
            this._moveStripContainer.parent.removeChild(this._moveStripContainer);
         }
         if(map)
         {
            map.animateSet.addAnimation(new BaseSetCenterAnimation(x,y - 150,50,false,AnimationLevel.MIDDLE));
            if(RoomManager.Instance.current.type != RoomInfo.ACTIVITY_DUNGEON_ROOM)
            {
               map.addEventListener(MouseEvent.CLICK,this.__mouseClick);
            }
         }
         this._shootTimer.removeEventListener(TimerEvent.TIMER,this.__shootTimer);
         setCollideRect(-8,-8,16,16);
         super.die();
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         _loc2_ = _map.globalToLocal(new Point(param1.stageX,param1.stageY));
         _map.addChild(this.mouseAsset);
         SoundManager.instance.play("041");
         this.mouseAsset.x = _loc2_.x;
         this.mouseAsset.y = _loc2_.y;
         this.mouseAsset.visible = true;
         GameInSocketOut.sendGhostTarget(_loc2_);
      }
      
      public function hideTargetMouseTip() : void
      {
         this.mouseAsset.visible = false;
      }
      
      override protected function __usingItem(param1:LivingEvent) : void
      {
         super.__usingItem(param1);
         if(param1.paras[0] is ItemTemplateInfo)
         {
            this.localPlayer.energy -= int(param1.paras[0].Property4);
         }
      }
      
      protected function __sendShoot(param1:LivingEvent) : void
      {
         this._shootPoint = shootPoint();
         this._shootCount = 0;
         this.shootOverCount = 0;
         this.localPlayer.isAttacking = false;
         this._isShooting = true;
         map.animateSet.addAnimation(new BaseSetCenterAnimation(x,y - 150,1,false,AnimationLevel.HIGHT));
         GameInSocketOut.sendGameCMDDirection(info.direction);
         GameInSocketOut.sendShootTag(true,this.localPlayer.shootTime);
         if(this.localPlayer.shootType == 0)
         {
            this.localPlayer.force = param1.paras[0];
            this._shootTimer.start();
            this.__shootTimer(null);
         }
         else
         {
            act(new PlayerBeatAction(this));
         }
      }
      
      private function __shootTimer(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if(this.localPlayer && this.localPlayer.isLiving && this._shootCount < this.localPlayer.shootCount)
         {
            _loc2_ = this.localPlayer.calcBombAngle();
            _loc3_ = this.localPlayer.force;
            GameInSocketOut.sendGameCMDShoot(this._shootPoint.x,this._shootPoint.y,_loc3_,_loc2_);
            MapView(_map).gameView.setRecordRotation();
            ++this._shootCount;
         }
      }
      
      override protected function __shoot(param1:LivingEvent) : void
      {
         super.__shoot(param1);
         this.localPlayer.lastFireBombs = param1.paras[0];
         if(RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            if(this._shootCount >= this.localPlayer.shootCount && map)
            {
               map.act(new FocusInLivingAction(map.getOneSimpleBoss));
            }
         }
      }
      
      override protected function __beginNewTurn(param1:LivingEvent) : void
      {
         super.__beginNewTurn(param1);
         map.act(new NewHandFightHelpIIAction(this.localPlayer,param1.value - param1.old));
         map.act(new NewHandFightHelpAction(this.localPlayer,this._shootOverCount,map));
         this._shootCount = 0;
         this.shootOverCount = 0;
         this._shootTimer.reset();
         if(_player.contains(this._takeAim))
         {
            _player.removeChild(this._takeAim);
         }
         this._isShooting = false;
      }
      
      public function get shootOverCount() : int
      {
         return this._shootOverCount;
      }
      
      public function set shootOverCount(param1:int) : void
      {
         this._shootOverCount = param1;
         if(this._shootOverCount == this._shootCount)
         {
            this._isShooting = false;
         }
      }
      
      protected function __gunangleChanged(param1:LivingEvent) : void
      {
         this._takeAim["hand"].rotation = this.localPlayer.gunAngle;
      }
      
      protected function __energyChanged(param1:LivingEvent) : void
      {
         if(this.localPlayer.isLiving)
         {
            this._moveStrip.scaleX = this.localPlayer.energy / this.localPlayer.maxEnergy;
         }
      }
      
      override protected function __usePetSkill(param1:LivingEvent) : void
      {
         if(_info.isLocked)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.campBattle.onlyFly"));
            return;
         }
         super.__usePetSkill(param1);
         var _loc2_:PetSkillTemplateInfo = PetSkillManager.getSkillByID(param1.value);
         if(_loc2_.isActiveSkill)
         {
            switch(_loc2_.BallType)
            {
               case 0:
               case 3:
                  this.localPlayer.spellKillEnabled = false;
                  break;
               case 1:
               case 2:
                  this.localPlayer.soulPropEnabled = this.localPlayer.propEnabled = this.localPlayer.flyEnabled = this.localPlayer.deputyWeaponEnabled = this.localPlayer.rightPropEnabled = this.localPlayer.spellKillEnabled = false;
            }
         }
      }
   }
}

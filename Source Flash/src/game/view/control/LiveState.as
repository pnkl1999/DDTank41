package game.view.control
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.FightPropMode;
   import ddt.events.FightPropEevnt;
   import ddt.events.LivingEvent;
   import ddt.events.SharedEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.LocalPlayer;
   import game.model.Player;
   import game.view.EnergyView;
   import game.view.arrow.ArrowView;
   import game.view.prop.CustomPropBar;
   import game.view.prop.PetSkillBar;
   import game.view.prop.RightPropBar;
   import game.view.prop.WeaponPropBar;
   import game.view.tool.ToolStripView;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class LiveState extends ControlState
   {
       
      
      protected var _arrow:ArrowView;
      
      protected var _energy:EnergyView;
      
      protected var _customPropBar:CustomPropBar;
      
      protected var _tool:ToolStripView;
      
      protected var _rightPropBar:RightPropBar;
      
      protected var _weaponPropBar:WeaponPropBar;
      
      private var _gameInfo:GameInfo;
      
      protected var _petSkill:PetSkillBar;
      
      protected var _petSkillIsShowBtn:BaseButton;
      
      protected var _petSkillBtnCurrentFrame:int;
      
      protected var _petSkillIsShowBtnTopY:Number;
      
      public function LiveState(param1:LocalPlayer)
      {
         this._gameInfo = GameManager.Instance.Current;
         super(param1);
      }
      
      override protected function configUI() : void
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc1_:Point = null;
         _loc2_ = null;
         _loc3_ = null;
         this._arrow = new ArrowView(_self);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("asset.game.ArrowViewPos");
         this._arrow.x = _loc1_.x;
         this._arrow.y = _loc1_.y;
         addChild(this._arrow);
         this._energy = new EnergyView(_self);
         _loc2_ = ComponentFactory.Instance.creatCustomObject("asset.game.energyPos");
         this._energy.x = _loc2_.x;
         this._energy.y = _loc2_.y;
         addChild(this._energy);
         this._customPropBar = ComponentFactory.Instance.creatCustomObject("LiveCustomPropBar",[_self,FightControlBar.LIVE]);
         addChild(this._customPropBar);
         if(_self.currentPet)
         {
            this._petSkill = new PetSkillBar(_self);
            PositionUtils.setPos(this._petSkill,"asset.game.petskillBarPos");
            if(this._gameInfo.mapIndex != 1405)
            {
               addChild(this._petSkill);
            }
            this._petSkillIsShowBtn = ComponentFactory.Instance.creatComponentByStylename("game.petSkillBarIsShowBtn");
            MovieClip(this._petSkillIsShowBtn.backgound).gotoAndStop(1);
            this._petSkillBtnCurrentFrame = 1;
            this._petSkillIsShowBtn.addEventListener(MouseEvent.CLICK,this.__onPetSillIsShowBtnClick);
            this._petSkillIsShowBtn.addEventListener(MouseEvent.ROLL_OVER,this.__onPetSillIsShowBtnOver);
            this._petSkillIsShowBtn.addEventListener(MouseEvent.ROLL_OUT,this.__onPetSillIsShowBtnOut);
            this._petSkillIsShowBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__onPetSillIsShowBtnMousedown);
            if(this._gameInfo.mapIndex != 1405)
            {
               addChild(this._petSkillIsShowBtn);
            }
            this._petSkillIsShowBtnTopY = this._petSkillIsShowBtn.y;
         }
         this._weaponPropBar = ComponentFactory.Instance.creatCustomObject("WeaponPropBar",[_self]);
         addChild(this._weaponPropBar);
         this._tool = new ToolStripView();
         _loc3_ = ComponentFactory.Instance.creatCustomObject("asset.game.toolPos");
         this._tool.x = _loc3_.x;
         this._tool.y = _loc3_.y;
         addChild(this._tool);
         this._rightPropBar = ComponentFactory.Instance.creatCustomObject("RightPropBar",[_self,this]);
         this.setPropBarVisible();
         super.configUI();
      }
      
      private function __onPetSillIsShowBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._petSkill.visible)
         {
            this._petSkillBtnCurrentFrame = 2;
            this._petSkill.visible = false;
            if(this._customPropBar)
            {
               this._petSkillIsShowBtn.y = this._customPropBar.y - this._petSkillIsShowBtn.height - 27;
            }
         }
         else
         {
            this._petSkillBtnCurrentFrame = 1;
            this._petSkill.visible = true;
            this._petSkillIsShowBtn.y = this._petSkillIsShowBtnTopY;
         }
         MovieClip(this._petSkillIsShowBtn.backgound).gotoAndStop(this._petSkillBtnCurrentFrame);
      }
      
      private function __onPetSillIsShowBtnOver(param1:MouseEvent) : void
      {
         MovieClip(this._petSkillIsShowBtn.backgound).gotoAndStop(this._petSkillBtnCurrentFrame);
      }
      
      private function __onPetSillIsShowBtnOut(param1:MouseEvent) : void
      {
         MovieClip(this._petSkillIsShowBtn.backgound).gotoAndStop(this._petSkillBtnCurrentFrame);
      }
      
      private function __onPetSillIsShowBtnMousedown(param1:MouseEvent) : void
      {
      }
      
      private function setPropBarVisible() : void
      {
         if(this._rightPropBar)
         {
            if(RoomManager.Instance.current.gameMode == 8)
            {
               this._rightPropBar.hidePropBar();
            }
         }
      }
      
      override protected function addEvent() : void
      {
         this._tool.addEventListener(FightPropEevnt.MODECHANGED,this.__propBarModeChanged);
         SharedManager.Instance.addEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
         super.addEvent();
      }
      
      protected function __transparentChanged(param1:Event) : void
      {
         if(SharedManager.Instance.propTransparent)
         {
            this._arrow.alpha = 0.5;
            this._energy.alpha = 0.5;
            if(this._customPropBar)
            {
               this._customPropBar.alpha = 0.5;
            }
            this._weaponPropBar.alpha = 0.5;
            if(this._petSkill)
            {
               this._petSkill.alpha = 0.5;
            }
            this._tool.alpha = 0.5;
            if(this._petSkillIsShowBtn)
            {
               this._petSkillIsShowBtn.alpha = 0.5;
            }
         }
         else
         {
            this._arrow.alpha = 1;
            if(this._petSkill)
            {
               this._petSkill.alpha = 1;
            }
            this._energy.alpha = 1;
            if(this._customPropBar)
            {
               this._customPropBar.alpha = 1;
            }
            this._weaponPropBar.alpha = 1;
            this._tool.alpha = 1;
            if(this._petSkillIsShowBtn)
            {
               this._petSkillIsShowBtn.alpha = 1;
            }
         }
      }
      
      override protected function removeEvent() : void
      {
         if(this._tool)
         {
            this._tool.removeEventListener(FightPropEevnt.MODECHANGED,this.__propBarModeChanged);
         }
         SharedManager.Instance.removeEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
         super.removeEvent();
      }
      
      private function __propBarModeChanged(param1:FightPropEevnt) : void
      {
         if(!this._rightPropBar.parent)
         {
            return;
         }
         if(SharedManager.Instance.propLayerMode == FightPropMode.HORIZONTAL)
         {
            this._rightPropBar.setMode(FightPropMode.VERTICAL);
            this._tool.setMode(FightPropMode.VERTICAL);
            SharedManager.Instance.propLayerMode = FightPropMode.VERTICAL;
         }
         else
         {
            this._rightPropBar.setMode(FightPropMode.HORIZONTAL);
            this._tool.setMode(FightPropMode.HORIZONTAL);
            SharedManager.Instance.propLayerMode = FightPropMode.HORIZONTAL;
         }
         SoundManager.instance.play("008");
      }
      
      override public function enter(param1:DisplayObjectContainer) : void
      {
         if(this._customPropBar)
         {
            this._customPropBar.enter();
            if(!this.contains(this._customPropBar))
            {
               addChild(this._customPropBar);
            }
         }
         this._weaponPropBar.enter();
         if(!this.contains(this._weaponPropBar) && GameManager.Instance.Current.mapIndex != 1405)
         {
            addChild(this._weaponPropBar);
         }
         this._energy.enter();
         this._arrow.enter();
         this._rightPropBar.setup(param1);
         this._rightPropBar.enter();
         this._gameInfo = GameManager.Instance.Current;
         if(WeakGuildManager.Instance.switchUserGuide)
         {
            this.loadWeakGuild();
         }
         this.__transparentChanged(null);
         super.enter(param1);
      }
      
      override public function leaving(param1:Function = null) : void
      {
         if(this._customPropBar)
         {
            this._customPropBar.leaving();
         }
         if(this._rightPropBar)
         {
            this._rightPropBar.leaving();
         }
         if(this._weaponPropBar)
         {
            this._weaponPropBar.leaving();
         }
         if(this._energy)
         {
            this._energy.leaving();
         }
         if(this._arrow)
         {
            this._arrow.leaving();
         }
         super.leaving(param1);
      }
      
      override protected function tweenIn() : void
      {
         y = 600;
         TweenLite.to(this,0.3,{"y":498});
      }
      
      protected function loadWeakGuild() : void
      {
         this.setWeaponPropVisible(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_OPEN));
         this._tool.setDanderEnable(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.POWER_OPEN));
         if(NewHandGuideManager.Instance.mapID == 111)
         {
            this.setArrowVisible(false);
            this.setEnergyVisible(false);
            this.setSelfPropBarVisible(false);
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_TEN_PERSENT))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.USE_TEN_PERSENT_TIP))
            {
               setTimeout(this.propOpenShow,2000,"asset.trainer.getAddTenPercent");
               this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__showTenPersentArrow);
               SocketManager.Instance.out.syncWeakStep(Step.USE_TEN_PERSENT_TIP);
            }
         }
         else
         {
            this.setRightPropVisible(false,7);
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_ADDONE))
         {
            this.setRightPropVisible(false,2);
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THREE_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THREE_SHOW))
            {
               setTimeout(this.propOpenShow,2000,"asset.trainer.getPowerThree");
               if(NewHandGuideManager.Instance.mapID != 114)
               {
                  this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__showThreeArrow);
               }
               SocketManager.Instance.out.syncWeakStep(Step.THREE_SHOW);
               SocketManager.Instance.out.syncWeakStep(Step.POWER_SHOW);
            }
         }
         else
         {
            this.setRightPropVisible(false,1);
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.POWER_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.POWER_TIP))
            {
               if(NewHandGuideManager.Instance.mapID != 114)
               {
                  this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__onDander);
                  this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.DANDER_CHANGED,this.__onDander);
               }
               SocketManager.Instance.out.syncWeakStep(Step.POWER_TIP);
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_SHOW))
         {
            setTimeout(this.propOpenShow,2000,"asset.trainer.getPlane");
            SocketManager.Instance.out.syncWeakStep(Step.PLANE_SHOW);
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.HP_PROP_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.ZXC_TIP))
         {
            if(PlayerManager.Instance.Self.FightBag.itemNumber != 0)
            {
               setTimeout(this.propOpenShow,2000,"asset.trainer.zxcTip");
               SocketManager.Instance.out.syncWeakStep(Step.ZXC_TIP);
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TWO_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TWO_SHOW))
            {
               setTimeout(this.propOpenShow,2000,"asset.trainer.getTwoTwenty");
               SocketManager.Instance.out.syncWeakStep(Step.TWO_SHOW);
            }
         }
         else
         {
            this.setRightPropVisible(false,0,6);
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THIRTY_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THIRTY_SHOW))
            {
               setTimeout(this.propOpenShow,2000,"asset.trainer.getThreeFourFive");
               SocketManager.Instance.out.syncWeakStep(Step.THIRTY_SHOW);
            }
         }
         else
         {
            this.setRightPropVisible(false,3,4,5);
         }
      }
      
      private function __onDander(param1:LivingEvent) : void
      {
         if(this._gameInfo.selfGamePlayer.isAttacking)
         {
            if(GameManager.Instance.Current.selfGamePlayer.dander >= Player.TOTAL_DANDER)
            {
               NewHandContainer.Instance.showArrow(ArrowType.TIP_POWER,-30,"trainer.posTipPower");
            }
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(-1);
         }
      }
      
      private function __showTenPersentArrow(param1:LivingEvent) : void
      {
         if(this._gameInfo.selfGamePlayer.isAttacking)
         {
            NewHandContainer.Instance.showArrow(ArrowType.TIP_TEN_PERCENT,-90,"trainer.posTipTenPercent");
            NewHandContainer.Instance.showArrow(ArrowType.TIP_ONE,-90,"trainer.posTipOne");
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(-1);
         }
      }
      
      private function __showThreeArrow(param1:LivingEvent) : void
      {
         if(this._gameInfo.selfGamePlayer.isAttacking)
         {
            NewHandContainer.Instance.showArrow(ArrowType.TIP_THREE,-90,"trainer.posTipThree");
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(-1);
         }
      }
      
      private function propOpenShow(param1:String) : void
      {
         var _loc2_:MovieClipWrapper = new MovieClipWrapper(ClassUtils.CreatInstance(param1),true,true);
         LayerManager.Instance.addToLayer(_loc2_.movie,LayerManager.GAME_UI_LAYER,false);
      }
      
      protected function setWeaponPropVisible(param1:Boolean) : void
      {
         this._weaponPropBar.setVisible(param1);
         if(param1)
         {
            if(!this._weaponPropBar.parent)
            {
               addChild(this._weaponPropBar);
            }
         }
         else if(this._weaponPropBar.parent)
         {
            this._weaponPropBar.parent.removeChild(this._weaponPropBar);
         }
      }
      
      protected function setRightPropVisible(param1:Boolean, ... rest) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < rest.length)
         {
            this._rightPropBar.setPropVisible(rest[_loc3_],param1);
            _loc3_++;
         }
      }
      
      protected function setSelfPropBarVisible(param1:Boolean) : void
      {
         this._customPropBar.setVisible(param1);
         if(param1)
         {
            if(!this._customPropBar.parent)
            {
               addChild(this._customPropBar);
            }
         }
         else if(this._customPropBar.parent)
         {
            this._customPropBar.parent.removeChild(this._customPropBar);
         }
      }
      
      protected function setArrowVisible(param1:Boolean) : void
      {
         this._arrow.visible = param1;
      }
      
      public function setEnergyVisible(param1:Boolean) : void
      {
         this._energy.visible = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._gameInfo)
         {
            this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__onDander);
            this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.DANDER_CHANGED,this.__onDander);
            this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__showThreeArrow);
            this._gameInfo = null;
         }
         ObjectUtils.disposeObject(this._arrow);
         this._arrow = null;
         ObjectUtils.disposeObject(this._energy);
         this._energy = null;
         ObjectUtils.disposeObject(this._customPropBar);
         this._customPropBar = null;
         ObjectUtils.disposeObject(this._weaponPropBar);
         this._weaponPropBar = null;
         ObjectUtils.disposeObject(this._tool);
         this._tool = null;
         ObjectUtils.disposeObject(this._rightPropBar);
         this._rightPropBar = null;
      }
   }
}

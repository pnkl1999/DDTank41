package hallIcon.view
{
   import accumulativeLogin.AccumulativeManager;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.BossBoxManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.bossbox.SmallBoxButton;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import hallIcon.event.HallIconEvent;
   import hallIcon.info.HallIconInfo;
   import littleGame.LittleGameManager;
   import newChickenBox.controller.NewChickenBoxManager;
   import noviceactivity.NoviceActivityManager;
   import roulette.LeftGunRouletteManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import worldboss.WorldBossManager;
   import chickActivation.ChickActivationManager;
   import luckStar.manager.LuckStarManager;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   
   public class HallRightIconView extends Sprite implements Disposeable
   {
       
      
      private var _iconBox:HBox;
      
      private var _boxButton:SmallBoxButton;
      
      private var _wonderFulPlay:HallIconPanel;
      
      private var _activity:HallIconPanel;
      
      private var _lastCreatTime:Number;
      
      private var _showArrowSp:Sprite;
      
      public function HallRightIconView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._showArrowSp = new Sprite();
         addChild(this._showArrowSp);
         this._iconBox = new HBox();
         this._iconBox.spacing = 5;
         addChild(this._iconBox);
         this.updateActivityIcon();
         this.updateWonderfulPlayIcon();
         this.checkShowBossBox();
      }
      
      private function initEvent() : void
      {
         HallIconManager.instance.model.addEventListener(HallIconEvent.UPDATE_RIGHTICON_VIEW,this.__updateIconViewHandler);
         HallIconManager.instance.model.addEventListener(HallIconEvent.UPDATE_BATCH_RIGHTICON_VIEW,this.__updateBatchIconViewHandler);
         HallIconManager.instance.addEventListener(HallIconEvent.CHECK_HALLICONEXPERIENCEOPEN,this.__checkHallIconExperienceOpenHandler);
      }
      
      private function addChildBox($child:DisplayObject) : void
      {
         this._iconBox.addChild($child);
         this._iconBox.arrange();
         this._iconBox.x = -this._iconBox.width;
      }
      
      private function __updateBatchIconViewHandler(evt:HallIconEvent) : void
      {
         var info:HallIconInfo = null;
         var dic:Dictionary = HallIconManager.instance.model.cacheRightIconDic;
         for each(info in dic)
         {
            this.updateIconView(info);
         }
      }
      
      private function __updateIconViewHandler(evt:HallIconEvent) : void
      {
         var iconInfo:HallIconInfo = HallIconInfo(evt.data);
         this.updateIconView(iconInfo);
      }
      
      private function updateIconView($iconInfo:HallIconInfo) : void
      {
         if($iconInfo.halltype == HallIcon.WONDERFULPLAY && this._wonderFulPlay)
         {
            this.commonUpdateIconPanelView(this._wonderFulPlay,$iconInfo,false);
         }
         else if($iconInfo.halltype == HallIcon.ACTIVITY && this._activity)
         {
            this.commonUpdateIconPanelView(this._activity,$iconInfo,true);
         }
         else
         {
            switch($iconInfo.icontype)
            {
               case HallIconType.WONDERFULPLAY:
                  this.updateWonderfulPlayIcon();
                  break;
               case HallIconType.ACTIVITY:
                  this.updateActivityIcon();
            }
         }
      }
      
      private function commonUpdateIconPanelView($hallIconPanel:HallIconPanel, $iconInfo:HallIconInfo, flag:Boolean = false) : void
      {
         var tempIcon:HallIcon = null;
         if($iconInfo.isopen)
         {
            tempIcon = $hallIconPanel.getIconByType($iconInfo.icontype) as HallIcon;
            if(!tempIcon)
            {
               tempIcon = $hallIconPanel.addIcon(this.createHallIconPanelIcon($iconInfo),$iconInfo.icontype,$iconInfo.orderid,flag) as HallIcon;
            }
            tempIcon.updateIcon($iconInfo);
         }
         else
         {
            $hallIconPanel.removeIconByType($iconInfo.icontype);
         }
         $hallIconPanel.arrange();
      }
      
      private function updateWonderfulPlayIcon() : void
      {
         if(HallIconManager.instance.model.wonderFulPlayIsOpen)
         {
            if(this._wonderFulPlay == null)
            {
               this._wonderFulPlay = new HallIconPanel("assets.hallIcon.wonderfulPlayIcon",HallIconPanel.BOTTOM,6);
               this._wonderFulPlay.addEventListener(MouseEvent.CLICK,this.__wonderFulPlayClickHandler);
               this.addChildBox(this._wonderFulPlay);
            }
         }
         else
         {
            this.removeWonderfulPlayIcon();
         }
      }
      
      private function checkShowBossBox() : void
      {
         if(BossBoxManager.instance.isShowBoxButton())
         {
            if(this._boxButton == null)
            {
               this._boxButton = new SmallBoxButton(SmallBoxButton.HALL_POINT);
            }
            this.addChildBox(this._boxButton);
         }
         else
         {
            this.removeBossBox();
         }
      }
      
      private function __wonderFulPlayClickHandler(evt:MouseEvent) : void
      {
         var icon:HallIcon = null;
         if(this._wonderFulPlay && evt.target == this._wonderFulPlay.mainIcon)
         {
            this.topIndex();
            this.checkNoneActivity(this._wonderFulPlay.count);
            this.checkRightIconTaskClickHandler(HallIcon.WONDERFULPLAY);
            return;
         }
         if(getTimer() - this._lastCreatTime < 1000)
         {
            return;
         }
         this._lastCreatTime = getTimer();
         if(evt.target is HallIcon)
         {
            icon = evt.target as HallIcon;
            if(icon.iconInfo.halltype == HallIcon.WONDERFULPLAY)
            {
               switch(icon.iconInfo.icontype)
               {
                  case HallIconType.LEAGUE:
                     SoundManager.instance.playButtonSound();
                     if(!WeakGuildManager.Instance.checkOpen(Step.GAME_ROOM_OPEN,20))
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",20));
                        return;
                     }
                     StateManager.setState(StateType.ROOM_LIST);
                     ComponentSetting.SEND_USELOG_ID(3);
                     if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_CLICKED))
                     {
                        SocketManager.Instance.out.syncWeakStep(Step.GAME_ROOM_CLICKED);
                     }
                     break;
                  case HallIconType.LITTLEGAMENOTE:
                     SoundManager.instance.play("008");
                     if(LittleGameManager.Instance.hasActive())
                     {
                        StateManager.setState(StateType.LITTLEHALL);
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
                     }
					 break;
				  case HallIconType.WORLDBOSSENTRANCE1:
					  SoundManager.instance.play("008");
					  if(WorldBossManager.Instance.isOpen)
					  {
						  StateManager.setState(StateType.WORLDBOSS_AWARD);
					  }
					  else
					  {
						  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
					  }
					  break;
				  case HallIconType.WANTSTRONG:
					  SoundManager.instance.play("008");
					  if(WorldBossManager.Instance.isOpen)
					  {
						  StateManager.setState(StateType.WORLDBOSS_AWARD);
					  }
					  else
					  {
						  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
					  }
					  break;
				  case HallIconType.WORLDBOSSENTRANCE4:
					  SoundManager.instance.play("008");
					  if(WorldBossManager.Instance.isOpen)
					  {
						  StateManager.setState(StateType.WORLDBOSS_AWARD);
					  }
					  else
					  {
						  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII"));
					  }
					  break;
				  default:
					  break;
               }
            }
         }
      }
      
      private function updateActivityIcon() : void
      {
         if(HallIconManager.instance.model.activityIsOpen)
         {
            if(this._activity == null)
            {
               this._activity = new HallIconPanel("assets.hallIcon.activityIcon",HallIconPanel.BOTTOM,6);
               this._activity.addEventListener(MouseEvent.CLICK,this.__activityClickHandler);
               this.addChildBox(this._activity);
            }
         }
         else
         {
            this.removeActivityIcon();
         }
      }
      
      private function __activityClickHandler(evt:MouseEvent) : void
      {
         var icon:HallIcon = null;
         if(this._activity && evt.target == this._activity.mainIcon)
         {
            this.topIndex();
            this.checkNoneActivity(this._activity.count);
            this.checkRightIconTaskClickHandler(HallIcon.ACTIVITY);
            return;
         }
         if(getTimer() - this._lastCreatTime < 1000)
         {
            return;
         }
         this._lastCreatTime = getTimer();
         if(evt.target is HallIcon)
         {
            icon = evt.target as HallIcon;
            if(icon.iconInfo.halltype == HallIcon.ACTIVITY)
            {
               switch(icon.iconInfo.icontype)
               {
                  case HallIconType.ACCUMULATIVE_LOGIN:
                     AccumulativeManager.instance.showFrame();
                     break;
                  case HallIconType.LIMITACTIVITY:
                     NoviceActivityManager.instance.show();
                     break;
                  case HallIconType.LEFTGUNROULETTE:
                     LeftGunRouletteManager.instance.showTurnplate();
                     break;
                  case HallIconType.NEWCHICKENBOX:
                     NewChickenBoxManager.instance.enterNewBoxView(evt);
					 break;
				  case HallIconType.CHICKACTIVATION:
					  SoundManager.instance.play("008");
					  ChickActivationManager.instance.showFrame();
					  break;
				  case HallIconType.LUCKSTAR:
					  LuckStarManager.Instance.onClickLuckyStarIocn(evt);
					  break;
				  case HallIconType.GUILDMEMBERWEEK:
					  GuildMemberWeekManager.instance.onClickguildMemberWeekIcon(evt);
					  break;
               }
            }
         }
      }
      
      public function createHallIconPanelIcon($iconInfo:HallIconInfo) : HallIcon
      {
         var iconString:String = null;
         switch($iconInfo.icontype)
         {
            case HallIconType.LEAGUE:
               iconString = "assets.hallIcon.leagueIcon";
               break;
            case HallIconType.ACCUMULATIVE_LOGIN:
               iconString = "assets.hallIcon.accumulativeLoginIcon";
               break;
            case HallIconType.LIMITACTIVITY:
               iconString = "assets.hallIcon.limitActivityIcon";
               break;
            case HallIconType.LEFTGUNROULETTE:
               iconString = "assets.hallIcon.rouletteGunIcon";
               break;
            case HallIconType.NEWCHICKENBOX:
               iconString = "assets.hallIcon.newChickenBoxIcon";
               break;
            case HallIconType.LITTLEGAMENOTE:
               iconString = "assets.hallIcon.littleGameNoteIcon";
			   break;
			case HallIconType.WORLDBOSSENTRANCE1:
			   iconString = "assets.hallIcon.worldBossEntrance_1";
			   break;
			case HallIconType.WANTSTRONG:
				iconString = "assets.hallIcon.devilTurnIcon";
				break;
			case HallIconType.WORLDBOSSENTRANCE4:
			   iconString = "assets.hallIcon.worldBossEntrance_4";
			   break;
			case HallIconType.CHICKACTIVATION:
				iconString = "assets.hallIcon.chickActivationIcon";
				break;
			case HallIconType.LUCKSTAR:
				iconString = "assets.hallIcon.luckyStarIcon";
				break;
			case HallIconType.GUILDMEMBERWEEK:
				iconString = "assets.hallIcon.guildmemberweekIcon";
				break;
			
         }
         return new HallIcon(iconString,$iconInfo);
      }
      
      public function getIconByType($hallType:int, $iconType:String) : DisplayObject
      {
         if($hallType == HallIcon.WONDERFULPLAY && this._wonderFulPlay)
         {
            return this._wonderFulPlay.getIconByType($iconType);
         }
         if($hallType == HallIcon.ACTIVITY && this._activity)
         {
            return this._activity.getIconByType($iconType);
         }
         return null;
      }
      
      private function topIndex() : void
      {
         if(this.parent && this.parent.numChildren > 1)
         {
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
         }
      }
      
      private function checkNoneActivity($count:int) : void
      {
         if($count <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.NoneActivity"));
         }
      }
      
      public function __checkHallIconExperienceOpenHandler(evt:HallIconEvent) : void
      {
         this.updateRightIconTaskArrow();
      }
      
      private function updateRightIconTaskArrow() : void
      {
         var step:int = 0;
         var posId:int = 0;
         var cacheRightIconTask:Object = HallIconManager.instance.model.cacheRightIconTask;
         if(cacheRightIconTask && !cacheRightIconTask.isCompleted && SharedManager.Instance.halliconExperienceStep < 2)
         {
            step = SharedManager.Instance.halliconExperienceStep;
            posId = 1;
            if(this._iconBox.numChildren == 3)
            {
               posId = 2;
            }
            else if(this._iconBox.numChildren == 4)
            {
               posId = 3;
            }
            else if(this._iconBox.numChildren == 5)
            {
               posId = 4;
            }
            if(step == 1)
            {
               posId += 1;
            }
            NewHandContainer.Instance.showArrow(ArrowType.HALLICON_EXPERIENCE,-90,"hallIcon.hallIconExperiencePos" + posId,"assets.hallIcon.experienceClickTxt","hallIcon.hallIconExperienceTxt" + posId,this._showArrowSp,0,true);
         }
         else if(NewHandContainer.Instance.hasArrow(ArrowType.HALLICON_EXPERIENCE))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.HALLICON_EXPERIENCE);
         }
      }
      
      private function checkRightIconTaskClickHandler($halltype:int) : void
      {
         if(!HallIconManager.instance.model.cacheRightIconTask)
         {
            return;
         }
         if($halltype == HallIcon.WONDERFULPLAY && SharedManager.Instance.halliconExperienceStep == 0)
         {
            SharedManager.Instance.halliconExperienceStep = 1;
            this.updateRightIconTaskArrow();
            SharedManager.Instance.save();
         }
         else if($halltype == HallIcon.ACTIVITY && SharedManager.Instance.halliconExperienceStep == 1)
         {
            SharedManager.Instance.halliconExperienceStep = 2;
            this.updateRightIconTaskArrow();
            SharedManager.Instance.halliconExperienceStep = 0;
            SharedManager.Instance.save();
         }
      }
      
      private function removeEvent() : void
      {
         HallIconManager.instance.model.removeEventListener(HallIconEvent.UPDATE_RIGHTICON_VIEW,this.__updateIconViewHandler);
         HallIconManager.instance.model.removeEventListener(HallIconEvent.UPDATE_BATCH_RIGHTICON_VIEW,this.__updateBatchIconViewHandler);
         HallIconManager.instance.removeEventListener(HallIconEvent.CHECK_HALLICONEXPERIENCEOPEN,this.__checkHallIconExperienceOpenHandler);
      }
      
      private function removeWonderfulPlayIcon() : void
      {
         if(this._wonderFulPlay)
         {
            this._wonderFulPlay.removeEventListener(MouseEvent.CLICK,this.__wonderFulPlayClickHandler);
            ObjectUtils.disposeObject(this._wonderFulPlay);
            this._wonderFulPlay = null;
         }
      }
      
      private function removeActivityIcon() : void
      {
         if(this._activity)
         {
            this._activity.removeEventListener(MouseEvent.CLICK,this.__activityClickHandler);
            ObjectUtils.disposeObject(this._activity);
            this._activity = null;
         }
      }
      
      private function removeBossBox() : void
      {
         if(this._boxButton)
         {
            ObjectUtils.disposeAllChildren(this._boxButton);
            ObjectUtils.disposeObject(this._boxButton);
            this._boxButton = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeWonderfulPlayIcon();
         this.removeActivityIcon();
         this.removeBossBox();
         if(NewHandContainer.Instance.hasArrow(ArrowType.HALLICON_EXPERIENCE))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.HALLICON_EXPERIENCE);
         }
         if(this._showArrowSp)
         {
            ObjectUtils.disposeAllChildren(this._showArrowSp);
            ObjectUtils.disposeObject(this._showArrowSp);
            this._showArrowSp = null;
         }
         if(this._iconBox)
         {
            ObjectUtils.disposeAllChildren(this._iconBox);
            ObjectUtils.disposeObject(this._iconBox);
            this._iconBox = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

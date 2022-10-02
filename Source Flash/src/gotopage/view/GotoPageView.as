package gotopage.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.dailyRecord.DailyRecordControl;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import eliteGame.EliteGameController;
   import farm.FarmModelController;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import setting.controll.SettingController;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   
   public class GotoPageView extends BaseAlerFrame
   {
       
      
      private var btnList:Vector.<SimpleBitmapButton>;
      
      private var _btnListContainer:SimpleTileList;
      
      public function GotoPageView()
      {
         super();
         this.initView();
      }
      
      override public function dispose() : void
      {
         GotoPageController.Instance.isShow = false;
         if(this.btnList)
         {
            this.clearBtn();
         }
         ObjectUtils.disposeObject(this._btnListContainer);
         this.btnList = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
      
      private function initView() : void
      {
         info = new AlertInfo(LanguageMgr.GetTranslation("tank.view.ChannelList.FastMenu.titleText"));
         _info.showSubmit = false;
         _info.showCancel = false;
         _info.moveEnable = false;
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.gotopage.icon");
         addToContent(_loc1_);
         this._btnListContainer = ComponentFactory.Instance.creatCustomObject("gotopage.btnListContainer",[2]);
         addToContent(this._btnListContainer);
         this.creatBtn();
      }
      
      private function creatBtn() : void
      {
         var _loc2_:SimpleBitmapButton = null;
         var _loc1_:int = 0;
         _loc2_ = null;
         this.btnList = new Vector.<SimpleBitmapButton>();
         _loc1_ = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = ComponentFactory.Instance.creat("gotopage.btn");
            _loc2_.alpha = 0;
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandle);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandle);
            _loc2_.addEventListener(MouseEvent.CLICK,this.__clickHandle);
            this._btnListContainer.addChild(_loc2_);
            this.btnList.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function clearBtn() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            if(this.btnList[_loc1_])
            {
               this.btnList[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandle);
               this.btnList[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this.__outHandle);
               this.btnList[_loc1_].removeEventListener(MouseEvent.CLICK,this.__clickHandle);
               ObjectUtils.disposeObject(this.btnList[_loc1_]);
            }
            this.btnList[_loc1_] = null;
            _loc1_++;
         }
      }
      
      private function __overHandle(param1:MouseEvent) : void
      {
         param1.currentTarget.alpha = 1;
      }
      
      private function __outHandle(param1:MouseEvent) : void
      {
         param1.currentTarget.alpha = 0;
      }
      
      private function __clickHandle(param1:MouseEvent) : void
      {
         var _loc3_:LeagueShowFrame = null;
         param1.stopImmediatePropagation();
         var _loc2_:int = this.btnList.indexOf(param1.currentTarget as SimpleBitmapButton);
         SoundManager.instance.play("047");
         switch(_loc2_)
         {
            case 0:
               if(!WeakGuildManager.Instance.checkOpen(Step.GAME_ROOM_OPEN,2))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",2));
                  return;
               }
               StateManager.setState(StateType.ROOM_LIST);
               ComponentSetting.SEND_USELOG_ID(117);
               break;
            case 1:
               if(!WeakGuildManager.Instance.checkOpen(Step.DUNGEON_OPEN,8))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",8));
                  return;
               }
               if(!PlayerManager.Instance.checkEnterDungeon)
               {
                  return;
               }
               StateManager.setState(StateType.DUNGEON_LIST);
               ComponentSetting.SEND_USELOG_ID(118);
               break;
            case 2:
               if(!WeakGuildManager.Instance.checkOpen(Step.CONSORTIA_OPEN,7))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",7));
                  return;
               }
               StateManager.setState(StateType.CONSORTIA);
               ComponentSetting.SEND_USELOG_ID(113);
               break;
            case 3:
               if(PlayerManager.Instance.Self.Grade < AcademyManager.TARGET_PLAYER_MIN_LEVEL)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",6));
                  return;
               }
               if(PlayerManager.Instance.Self.apprenticeshipState == AcademyManager.NONE_STATE)
               {
                  StateManager.setState(StateType.ACADEMY_REGISTRATION);
               }
               else
               {
                  StateManager.setState(StateType.ACADEMY_REGISTRATION);
               }
               ComponentSetting.SEND_USELOG_ID(119);
               break;
            case 4:
               if(!WeakGuildManager.Instance.checkOpen(Step.AUCTION_OPEN,14))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",14));
                  return;
               }
               StateManager.setState(StateType.AUCTION);
               ComponentSetting.SEND_USELOG_ID(114);
               break;
            case 5:
               DailyRecordControl.Instance.alertDailyFrame();
               break;
            case 6:
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("gotopage.leagueShowFrame");
               LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
               break;
            case 7:
               SettingController.Instance.switchVisible();
               break;
            case 8:
               EliteGameController.Instance.alertPreview();
               break;
            case 9:
               if(PlayerManager.Instance.Self.Grade < AcademyManager.FARM_PLAYER_MIN_LEVEL)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",25));
                  return;
               }
               FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
         }
         dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
      }
   }
}

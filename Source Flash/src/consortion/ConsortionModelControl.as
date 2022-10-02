package consortion
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.analyze.ConsortionApplyListAnalyzer;
   import consortion.analyze.ConsortionBuildingUseConditionAnalyer;
   import consortion.analyze.ConsortionDutyListAnalyzer;
   import consortion.analyze.ConsortionEventListAnalyzer;
   import consortion.analyze.ConsortionInventListAnalyzer;
   import consortion.analyze.ConsortionLevelUpAnalyzer;
   import consortion.analyze.ConsortionListAnalyzer;
   import consortion.analyze.ConsortionMemberAnalyer;
   import consortion.analyze.ConsortionPollListAnalyzer;
   import consortion.analyze.ConsortionSkillInfoAnalyzer;
   import consortion.data.BadgeInfo;
   import consortion.data.ConsortiaAssetLevelOffer;
   import consortion.event.ConsortionEvent;
   import consortion.view.selfConsortia.ConsortionBankFrame;
   import consortion.view.selfConsortia.ConsortionQuitFrame;
   import consortion.view.selfConsortia.ConsortionShopFrame;
   import consortion.view.selfConsortia.ManagerFrame;
   import consortion.view.selfConsortia.TakeInMemberFrame;
   import consortion.view.selfConsortia.TaxFrame;
   import consortion.view.selfConsortia.consortiaTask.ConsortiaTaskModel;
   import ddt.constants.CacheConsts;
   import ddt.data.ConsortiaInfo;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.BadgeInfoManager;
   import ddt.manager.ChatManager;
   import ddt.manager.ExternalInterfaceManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.utils.RequestVairableCreater;
   import flash.display.InteractiveObject;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import road7th.comm.PackageIn;
   import road7th.utils.DateUtils;
   import road7th.utils.StringHelper;
   
   public class ConsortionModelControl extends EventDispatcher
   {
      
      private static var _instance:ConsortionModelControl;
       
      
      private var _model:ConsortionModel;
      
      private var _taskModel:ConsortiaTaskModel;
      
      private var str:String;
      
      private var _invateID:int;
      
      private var _enterConfirm:BaseAlerFrame;
      
      public var quitConstrion:Boolean = false;
      
      public function ConsortionModelControl()
      {
         super();
         this._model = new ConsortionModel();
         this._taskModel = new ConsortiaTaskModel();
         this.addEvent();
      }
      
      public static function get Instance() : ConsortionModelControl
      {
         if(_instance == null)
         {
            _instance = new ConsortionModelControl();
         }
         return _instance;
      }
      
      public function get model() : ConsortionModel
      {
         return this._model;
      }
      
      public function get TaskModel() : ConsortiaTaskModel
      {
         return this._taskModel;
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN,this.__consortiaTryIn);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN_DEL,this.__tryInDel);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TRYIN_PASS,this.__consortiaTryInPass);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_DISBAND,this.__consortiaDisband);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_INVITE,this.__consortiaInvate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_INVITE_PASS,this.__consortiaInvitePass);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_CREATE,this.__consortiaCreate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_PLACARD_UPDATE,this.__consortiaPlacardUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_EQUIP_CONTROL,this.__onConsortiaEquipControl);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_RICHES_OFFER,this.__givceOffer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_RESPONSE,this.__consortiaResponse);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_RENEGADE,this.__renegadeUser);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_LEVEL_UP,this.__onConsortiaLevelUp);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_CHAIRMAN_CHAHGE,this.__oncharmanChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_USER_GRADE_UPDATE,this.__consortiaUserUpGrade);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_DESCRIPTION_UPDATE,this.__consortiaDescriptionUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SKILL_SOCKET,this.__skillChangehandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_MAIL_MESSAGE,this.__consortiaMailMessage);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_BADGE,this.__buyBadgeHandler);
      }
      
      private function __consortiaResponse(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:ConsortiaPlayerInfo = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc14_:String = null;
         var _loc15_:int = 0;
         var _loc16_:String = null;
         var _loc17_:int = 0;
         var _loc18_:String = null;
         var _loc19_:int = 0;
         var _loc20_:String = null;
         var _loc21_:int = 0;
         var _loc22_:String = null;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:String = null;
         var _loc28_:int = 0;
         var _loc29_:String = null;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:String = null;
         var _loc33_:int = 0;
         var _loc34_:int = 0;
         var _loc35_:String = null;
         var _loc36_:int = 0;
         var _loc37_:String = null;
         var _loc38_:int = 0;
         var _loc39_:String = null;
         var _loc40_:String = null;
         var _loc41_:InteractiveObject = null;
         var _loc42_:String = null;
         var _loc43_:String = null;
         var _loc44_:String = null;
         _loc2_ = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         switch(_loc3_)
         {
            case 1:
               this.quitConstrion = false;
               _loc6_ = new ConsortiaPlayerInfo();
               _loc6_.privateID = _loc2_.readInt();
               _loc7_ = _loc2_.readBoolean();
               _loc6_.ConsortiaID = _loc2_.readInt();
               _loc6_.ConsortiaName = _loc2_.readUTF();
               _loc6_.ID = _loc2_.readInt();
               _loc6_.NickName = _loc2_.readUTF();
               _loc8_ = _loc2_.readInt();
               _loc9_ = _loc2_.readUTF();
               _loc6_.DutyID = _loc2_.readInt();
               _loc6_.DutyName = _loc2_.readUTF();
               _loc6_.Offer = _loc2_.readInt();
               _loc6_.RichesOffer = _loc2_.readInt();
               _loc6_.RichesRob = _loc2_.readInt();
               _loc6_.LastDate = _loc2_.readDateString();
               _loc6_.Grade = _loc2_.readInt();
               _loc6_.DutyLevel = _loc2_.readInt();
               _loc10_ = _loc2_.readInt();
               _loc6_.playerState = new PlayerState(_loc10_);
               _loc6_.Sex = _loc2_.readBoolean();
               _loc6_.Right = _loc2_.readInt();
               _loc6_.WinCount = _loc2_.readInt();
               _loc6_.TotalCount = _loc2_.readInt();
               _loc6_.EscapeCount = _loc2_.readInt();
               _loc6_.Repute = _loc2_.readInt();
               _loc6_.LoginName = _loc2_.readUTF();
               _loc6_.FightPower = _loc2_.readInt();
               _loc6_.AchievementPoint = _loc2_.readInt();
               _loc6_.honor = _loc2_.readUTF();
               _loc6_.UseOffer = _loc2_.readInt();
               if(!(_loc7_ && _loc6_.ID == PlayerManager.Instance.Self.ID))
               {
                  if(_loc6_.ID == PlayerManager.Instance.Self.ID)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.one",_loc6_.ConsortiaName));
                  }
               }
               _loc11_ = "";
               if(_loc6_.ID == PlayerManager.Instance.Self.ID)
               {
                  this.setPlayerConsortia(_loc6_.ConsortiaID,_loc6_.ConsortiaName);
                  this.getConsortionMember(this.memberListComplete);
                  this.getConsortionList(this.selfConsortionComplete,1,6,_loc6_.ConsortiaName,-1,-1,-1,_loc6_.ConsortiaID);
                  if(_loc7_)
                  {
                     _loc11_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.isInvent.msg",_loc6_.ConsortiaName);
                  }
                  else
                  {
                     _loc11_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.pass",_loc6_.ConsortiaName);
                  }
                  if(StateManager.currentStateType == StateType.CONSORTIA)
                  {
                     dispatchEvent(new ConsortionEvent(ConsortionEvent.CONSORTION_STATE_CHANGE));
                  }
                  TaskManager.requestClubTask();
                  if(PathManager.solveExternalInterfaceEnabel())
                  {
                     ExternalInterfaceManager.sendToAgent(5,PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName,ServerManager.Instance.zoneName,-1,_loc6_.ConsortiaName);
                  }
               }
               else
               {
                  this._model.addMember(_loc6_);
                  _loc11_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.player",_loc6_.NickName);
               }
               _loc11_ = StringHelper.rePlaceHtmlTextField(_loc11_);
               ChatManager.Instance.sysChatYellow(_loc11_);
               break;
            case 2:
               this.quitConstrion = true;
               _loc4_ = _loc2_.readInt();
               PlayerManager.Instance.Self.consortiaInfo.Level = 0;
               this.setPlayerConsortia();
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.your"));
               this.getConsortionMember();
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.manager.PlayerManager.disband"));
               if(StateManager.currentStateType == StateType.CONSORTIA)
               {
                  StateManager.back();
               }
               break;
            case 3:
               this.quitConstrion = true;
               _loc4_ = _loc2_.readInt();
               _loc12_ = _loc2_.readInt();
               _loc13_ = _loc2_.readBoolean();
               _loc5_ = _loc2_.readUTF();
               _loc14_ = _loc2_.readUTF();
               if(PlayerManager.Instance.Self.ID == _loc4_)
               {
                  this.setPlayerConsortia();
                  this.getConsortionMember();
                  TaskManager.onGuildUpdate();
                  _loc39_ = "";
                  if(_loc13_)
                  {
                     _loc39_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.delect",_loc14_);
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.hit"));
                  }
                  else
                  {
                     _loc39_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.leave");
                  }
                  if(StateManager.currentStateType == StateType.CONSORTIA)
                  {
                     StateManager.back();
                  }
                  _loc39_ = StringHelper.rePlaceHtmlTextField(_loc39_);
                  ChatManager.Instance.sysChatRed(_loc39_);
               }
               else
               {
                  this.removeConsortiaMember(_loc4_,_loc13_,_loc14_);
               }
               break;
            case 4:
               this.quitConstrion = false;
               this._invateID = _loc2_.readInt();
               _loc15_ = _loc2_.readInt();
               _loc16_ = _loc2_.readUTF();
               _loc17_ = _loc2_.readInt();
               _loc18_ = _loc2_.readUTF();
               _loc19_ = _loc2_.readInt();
               _loc20_ = _loc2_.readUTF();
               if(SharedManager.Instance.showCI)
               {
                  if(this.str != _loc18_)
                  {
                     SoundManager.instance.play("018");
                     _loc40_ = _loc18_ + LanguageMgr.GetTranslation("tank.manager.PlayerManager.come",_loc20_);
                     _loc40_ = StringHelper.rePlaceHtmlTextField(_loc40_);
                     _loc41_ = StageReferance.stage.focus;
                     if(this._enterConfirm)
                     {
                        this._enterConfirm.removeEventListener(FrameEvent.RESPONSE,this.__enterConsortiaConfirm);
                        ObjectUtils.disposeObject(this._enterConfirm);
                        this._enterConfirm = null;
                     }
                     this._enterConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.manager.PlayerManager.request"),_loc40_,LanguageMgr.GetTranslation("tank.manager.PlayerManager.sure"),LanguageMgr.GetTranslation("tank.manager.PlayerManager.refuse"),false,true,true,LayerManager.ALPHA_BLOCKGOUND,CacheConsts.ALERT_IN_FIGHT);
                     this._enterConfirm.addEventListener(FrameEvent.RESPONSE,this.__enterConsortiaConfirm);
                     this.str = _loc18_;
                     if(_loc41_ is TextField)
                     {
                        if(TextField(_loc41_).type == TextFieldType.INPUT)
                        {
                           StageReferance.stage.focus = _loc41_;
                        }
                     }
                  }
               }
               break;
            case 5:
               break;
            case 6:
               _loc21_ = _loc2_.readInt();
               _loc22_ = _loc2_.readUTF();
               _loc23_ = _loc2_.readInt();
               if(PlayerManager.Instance.Self.ConsortiaID == _loc21_)
               {
                  PlayerManager.Instance.Self.consortiaInfo.Level = _loc23_;
                  ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.manager.PlayerManager.upgrade",_loc23_,this._model.getLevelData(_loc23_).Count));
                  TaskManager.requestClubTask();
                  SoundManager.instance.play("1001");
                  this.getConsortionList(this.selfConsortionComplete,1,6,PlayerManager.Instance.Self.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
                  TaskManager.onGuildUpdate();
               }
               break;
            case 7:
               break;
            case 8:
               _loc24_ = _loc2_.readByte();
               _loc25_ = _loc2_.readInt();
               _loc26_ = _loc2_.readInt();
               _loc27_ = _loc2_.readUTF();
               _loc28_ = _loc2_.readInt();
               _loc29_ = _loc2_.readUTF();
               _loc30_ = _loc2_.readInt();
               _loc31_ = _loc2_.readInt();
               _loc32_ = _loc2_.readUTF();
               if(_loc24_ != 1)
               {
                  if(_loc24_ == 2)
                  {
                     this.updateDutyInfo(_loc28_,_loc29_,_loc30_);
                  }
                  else if(_loc24_ == 3)
                  {
                     this.upDateSelfDutyInfo(_loc28_,_loc29_,_loc30_);
                  }
                  else if(_loc24_ == 4)
                  {
                     this.upDateSelfDutyInfo(_loc28_,_loc29_,_loc30_);
                  }
                  else if(_loc24_ == 5)
                  {
                     this.upDateSelfDutyInfo(_loc28_,_loc29_,_loc30_);
                  }
                  else if(_loc24_ == 6)
                  {
                     this.updateConsortiaMemberDuty(_loc26_,_loc28_,_loc29_,_loc30_);
                     _loc42_ = "";
                     if(_loc26_ == PlayerManager.Instance.Self.ID)
                     {
                        _loc42_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.youUpgrade",_loc32_,_loc29_);
                     }
                     else if(_loc26_ == _loc31_)
                     {
                        _loc42_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.upgradeSelf",_loc27_,_loc29_);
                     }
                     else
                     {
                        _loc42_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.upgradeOther",_loc32_,_loc27_,_loc29_);
                     }
                     _loc42_ = StringHelper.rePlaceHtmlTextField(_loc42_);
                     ChatManager.Instance.sysChatYellow(_loc42_);
                  }
                  else if(_loc24_ == 7)
                  {
                     this.updateConsortiaMemberDuty(_loc26_,_loc28_,_loc29_,_loc30_);
                     _loc43_ = "";
                     if(_loc26_ == PlayerManager.Instance.Self.ID)
                     {
                        _loc43_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.youDemotion",_loc32_,_loc29_);
                     }
                     else if(_loc26_ == _loc31_)
                     {
                        _loc43_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.demotionSelf",_loc27_,_loc29_);
                     }
                     else
                     {
                        _loc43_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.demotionOther",_loc32_,_loc27_,_loc29_);
                     }
                     _loc43_ = StringHelper.rePlaceHtmlTextField(_loc43_);
                     ChatManager.Instance.sysChatYellow(_loc43_);
                  }
                  else if(_loc24_ == 8)
                  {
                     this.updateConsortiaMemberDuty(_loc26_,_loc28_,_loc29_,_loc30_);
                     SoundManager.instance.play("1001");
                  }
                  else if(_loc24_ == 9)
                  {
                     this.updateConsortiaMemberDuty(_loc26_,_loc28_,_loc29_,_loc30_);
                     PlayerManager.Instance.Self.consortiaInfo.ChairmanName = _loc27_;
                     _loc44_ = "<" + _loc27_ + ">" + LanguageMgr.GetTranslation("tank.manager.PlayerManager.up") + _loc29_;
                     _loc44_ = StringHelper.rePlaceHtmlTextField(_loc44_);
                     ChatManager.Instance.sysChatYellow(_loc44_);
                     SoundManager.instance.play("1001");
                  }
               }
               break;
            case 9:
               _loc33_ = _loc2_.readInt();
               _loc34_ = _loc2_.readInt();
               _loc35_ = _loc2_.readUTF();
               _loc36_ = _loc2_.readInt();
               if(_loc33_ != PlayerManager.Instance.Self.ConsortiaID)
               {
                  return;
               }
               _loc37_ = "";
               if(PlayerManager.Instance.Self.ID == _loc34_)
               {
                  _loc37_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.contributionSelf",_loc36_);
               }
               else
               {
                  _loc37_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.contributionOther",_loc35_,_loc36_);
               }
               ChatManager.Instance.sysChatYellow(_loc37_);
               break;
            case 10:
               this.consortiaUpLevel(10,_loc2_.readInt(),_loc2_.readUTF(),_loc2_.readInt());
               break;
            case 11:
               this.consortiaUpLevel(11,_loc2_.readInt(),_loc2_.readUTF(),_loc2_.readInt());
               break;
            case 12:
               this.consortiaUpLevel(12,_loc2_.readInt(),_loc2_.readUTF(),_loc2_.readInt());
               break;
            case 13:
               this.consortiaUpLevel(13,_loc2_.readInt(),_loc2_.readUTF(),_loc2_.readInt());
               break;
            case 14:
               _loc38_ = _loc2_.readInt();
               switch(_loc38_)
               {
                  case 1:
                     PlayerManager.Instance.Self.consortiaInfo.IsVoting = true;
                     break;
                  case 2:
                     PlayerManager.Instance.Self.consortiaInfo.IsVoting = false;
                     break;
                  case 3:
                     PlayerManager.Instance.Self.consortiaInfo.IsVoting = false;
               }
               break;
            case 15:
               _loc2_.readInt();
               ChatManager.Instance.sysChatYellow(_loc2_.readUTF());
               break;
            case 16:
               this.getConsortionList(this.selfConsortionComplete,1,6,PlayerManager.Instance.Self.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
         }
      }
      
      private function consortiaUpLevel(param1:int, param2:int, param3:String, param4:int) : void
      {
         if(param2 != PlayerManager.Instance.Self.ConsortiaID)
         {
            return;
         }
         SoundManager.instance.play("1001");
         var _loc5_:String = "";
         if(param1 == 10)
         {
            if(PlayerManager.Instance.Self.DutyLevel == 1)
            {
               _loc5_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaShop",param4);
            }
            else
            {
               _loc5_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaShop2",param4);
            }
            PlayerManager.Instance.Self.consortiaInfo.ShopLevel = param4;
         }
         else if(param1 == 11)
         {
            if(PlayerManager.Instance.Self.DutyLevel == 1)
            {
               _loc5_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaStore",param4);
            }
            else
            {
               _loc5_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaStore2",param4);
            }
            PlayerManager.Instance.Self.consortiaInfo.SmithLevel = param4;
         }
         else if(param1 == 12)
         {
            if(PlayerManager.Instance.Self.DutyLevel == 1)
            {
               _loc5_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaSmith",param4);
            }
            else
            {
               _loc5_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaSmith2",param4);
            }
            PlayerManager.Instance.Self.consortiaInfo.StoreLevel = param4;
         }
         else if(param1 == 13)
         {
            if(PlayerManager.Instance.Self.DutyLevel == 1)
            {
               _loc5_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaSkill",param4);
            }
            else
            {
               _loc5_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortiaSkill2",param4);
            }
            PlayerManager.Instance.Self.consortiaInfo.BufferLevel = param4;
         }
         ChatManager.Instance.sysChatYellow(_loc5_);
         this.getConsortionList(this.selfConsortionComplete,1,6,PlayerManager.Instance.Self.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
         TaskManager.onGuildUpdate();
      }
      
      private function updateDutyInfo(param1:int, param2:String, param3:int) : void
      {
         var _loc4_:ConsortiaPlayerInfo = null;
         for each(_loc4_ in this._model.memberList)
         {
            if(_loc4_.DutyLevel == param1)
            {
               _loc4_.DutyLevel == param1;
               _loc4_.DutyName = param2;
               _loc4_.Right = param3;
               this._model.updataMember(_loc4_);
            }
         }
      }
      
      private function upDateSelfDutyInfo(param1:int, param2:String, param3:int) : void
      {
         var _loc4_:ConsortiaPlayerInfo = null;
         for each(_loc4_ in this._model.memberList)
         {
            if(_loc4_.ID == PlayerManager.Instance.Self.ID)
            {
               PlayerManager.Instance.Self.beginChanges();
               _loc4_.DutyLevel = PlayerManager.Instance.Self.DutyLevel = param1;
               _loc4_.DutyName = PlayerManager.Instance.Self.DutyName = param2;
               _loc4_.Right = PlayerManager.Instance.Self.Right = param3;
               PlayerManager.Instance.Self.commitChanges();
               this._model.updataMember(_loc4_);
            }
         }
      }
      
      private function updateConsortiaMemberDuty(param1:int, param2:int, param3:String, param4:int) : void
      {
         var _loc5_:ConsortiaPlayerInfo = null;
         for each(_loc5_ in this._model.memberList)
         {
            if(_loc5_.ID == param1)
            {
               _loc5_.beginChanges();
               _loc5_.DutyLevel = param2;
               _loc5_.DutyName = param3;
               _loc5_.Right = param4;
               if(_loc5_.ID == PlayerManager.Instance.Self.ID)
               {
                  PlayerManager.Instance.Self.beginChanges();
                  PlayerManager.Instance.Self.DutyLevel = param2;
                  PlayerManager.Instance.Self.DutyName = param3;
                  PlayerManager.Instance.Self.Right = param4;
                  PlayerManager.Instance.Self.consortiaInfo.Level = PlayerManager.Instance.Self.consortiaInfo.Level == 0 ? int(int(1)) : int(int(PlayerManager.Instance.Self.consortiaInfo.Level));
                  PlayerManager.Instance.Self.commitChanges();
                  this.getConsortionList(this.selfConsortionComplete,1,6,PlayerManager.Instance.Self.consortiaInfo.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.consortiaInfo.ConsortiaID);
               }
               _loc5_.commitChanges();
               this._model.updataMember(_loc5_);
            }
         }
      }
      
      private function removeConsortiaMember(param1:int, param2:Boolean, param3:String) : void
      {
         var _loc4_:ConsortiaPlayerInfo = null;
         var _loc5_:String = null;
         for each(_loc4_ in this._model.memberList)
         {
            if(_loc4_.ID == param1)
            {
               _loc5_ = "";
               if(param2)
               {
                  _loc5_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.consortia",param3,_loc4_.NickName);
               }
               else
               {
                  _loc5_ = LanguageMgr.GetTranslation("tank.manager.PlayerManager.leaveconsortia",_loc4_.NickName);
               }
               _loc5_ = StringHelper.rePlaceHtmlTextField(_loc5_);
               ChatManager.Instance.sysChatYellow(_loc5_);
               this._model.removeMember(_loc4_);
            }
         }
      }
      
      private function __enterConsortiaConfirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__enterConsortiaConfirm);
         if(_loc2_)
         {
            ObjectUtils.disposeObject(_loc2_);
            _loc2_ = null;
         }
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.accpetConsortiaInvent();
         }
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.CANCEL_CLICK)
         {
            this.rejectConsortiaInvent();
         }
      }
      
      private function accpetConsortiaInvent() : void
      {
         SocketManager.Instance.out.sendConsortiaInvatePass(this._invateID);
         this.str = "";
      }
      
      private function rejectConsortiaInvent() : void
      {
         SocketManager.Instance.out.sendConsortiaInvateDelete(this._invateID);
         this.str = "";
      }
      
      private function __givceOffer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         var _loc4_:String = param1.pkg.readUTF();
         MessageTipManager.getInstance().show(_loc4_);
         if(_loc3_)
         {
            PlayerManager.Instance.Self.consortiaInfo.Riches += Math.floor(Number(_loc2_ / 2));
            this._model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID).RichesOffer = this._model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID).RichesOffer + Math.floor(Number(_loc2_ / 2));
            TaskManager.onGuildUpdate();
         }
      }
      
      private function __onConsortiaEquipControl(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Vector.<ConsortiaAssetLevelOffer> = new Vector.<ConsortiaAssetLevelOffer>();
         var _loc3_:int = 0;
         while(_loc3_ < 7)
         {
            _loc2_[_loc3_] = new ConsortiaAssetLevelOffer();
            if(_loc3_ < 5)
            {
               _loc2_[_loc3_].Type = 1;
               _loc2_[_loc3_].Level = _loc3_ + 1;
            }
            else if(_loc3_ == 5)
            {
               _loc2_[_loc3_].Type = 2;
            }
            else
            {
               _loc2_[_loc3_].Type = 3;
            }
            _loc3_++;
         }
         _loc2_[0].Riches = param1.pkg.readInt();
         _loc2_[1].Riches = param1.pkg.readInt();
         _loc2_[2].Riches = param1.pkg.readInt();
         _loc2_[3].Riches = param1.pkg.readInt();
         _loc2_[4].Riches = param1.pkg.readInt();
         _loc2_[5].Riches = param1.pkg.readInt();
         _loc2_[6].Riches = param1.pkg.readInt();
         var _loc4_:Boolean = param1.pkg.readBoolean();
         var _loc5_:String = param1.pkg.readUTF();
         MessageTipManager.getInstance().show(_loc5_);
         if(_loc4_)
         {
            this._model.useConditionList = _loc2_;
         }
      }
      
      private function __consortiaTryIn(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         var _loc4_:String = param1.pkg.readUTF();
         MessageTipManager.getInstance().show(_loc4_);
         if(_loc3_)
         {
            this.getApplyRecordList(this.applyListComplete,PlayerManager.Instance.Self.ID);
         }
      }
      
      private function __tryInDel(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         var _loc4_:String = param1.pkg.readUTF();
         MessageTipManager.getInstance().show(_loc4_);
         if(_loc3_)
         {
            this._model.deleteOneApplyRecord(_loc2_);
         }
      }
      
      private function __consortiaTryInPass(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         var _loc4_:String = param1.pkg.readUTF();
         MessageTipManager.getInstance().show(_loc4_);
         this._model.deleteOneApplyRecord(_loc2_);
      }
      
      private function __consortiaInvate(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = param1.pkg.readUTF();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         var _loc4_:String = param1.pkg.readUTF();
         MessageTipManager.getInstance().show(_loc4_);
      }
      
      private function __consortiaInvitePass(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:String = param1.pkg.readUTF();
         MessageTipManager.getInstance().show(param1.pkg.readUTF());
         if(_loc3_)
         {
            this.setPlayerConsortia(_loc4_,_loc5_);
            this.getConsortionMember(this.memberListComplete);
            this.getConsortionList(this.selfConsortionComplete,1,6,_loc5_,-1,-1,-1,_loc4_);
         }
      }
      
      private function __consortiaCreate(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = param1.pkg.readUTF();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:String = param1.pkg.readUTF();
         var _loc6_:String = param1.pkg.readUTF();
         MessageTipManager.getInstance().show(_loc6_);
         var _loc7_:int = param1.pkg.readInt();
         var _loc8_:String = param1.pkg.readUTF();
         var _loc9_:int = param1.pkg.readInt();
         if(_loc3_)
         {
            this.setPlayerConsortia(_loc4_,_loc2_);
            this.getConsortionMember(this.memberListComplete);
            this.getConsortionList(this.selfConsortionComplete,1,6,_loc2_,-1,-1,-1,_loc4_);
            dispatchEvent(new ConsortionEvent(ConsortionEvent.CONSORTION_STATE_CHANGE));
            TaskManager.requestClubTask();
            if(PathManager.solveExternalInterfaceEnabel())
            {
               ExternalInterfaceManager.sendToAgent(4,PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName,ServerManager.Instance.zoneName,-1,_loc5_);
            }
         }
      }
      
      private function __consortiaDisband(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(param1.pkg.readBoolean())
         {
            if(param1.pkg.readInt() == PlayerManager.Instance.Self.ID)
            {
               this.setPlayerConsortia();
               if(StateManager.currentStateType == StateType.CONSORTIA)
               {
                  StateManager.back();
               }
               ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.manager.PlayerManager.msg"));
               MessageTipManager.getInstance().show(param1.pkg.readUTF());
            }
         }
         else
         {
            _loc2_ = param1.pkg.readInt();
            _loc3_ = param1.pkg.readUTF();
            MessageTipManager.getInstance().show(_loc3_);
         }
      }
      
      private function __consortiaPlacardUpdate(param1:CrazyTankSocketEvent) : void
      {
         PlayerManager.Instance.Self.consortiaInfo.Placard = param1.pkg.readUTF();
         var _loc2_:Boolean = param1.pkg.readBoolean();
         var _loc3_:String = param1.pkg.readUTF();
         MessageTipManager.getInstance().show(_loc3_);
      }
      
      private function __renegadeUser(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         var _loc4_:String = param1.pkg.readUTF();
         MessageTipManager.getInstance().show(_loc4_);
      }
      
      private function __onConsortiaLevelUp(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readByte();
         var _loc3_:int = param1.pkg.readByte();
         var _loc4_:Boolean = param1.pkg.readBoolean();
         var _loc5_:String = param1.pkg.readUTF();
         MessageTipManager.getInstance().show(_loc5_);
         if(_loc4_)
         {
            switch(_loc2_)
            {
               case 1:
                  PlayerManager.Instance.Self.consortiaInfo.Level = _loc3_;
                  break;
               case 2:
                  PlayerManager.Instance.Self.consortiaInfo.StoreLevel = _loc3_;
                  break;
               case 3:
                  PlayerManager.Instance.Self.consortiaInfo.ShopLevel = _loc3_;
                  break;
               case 4:
                  PlayerManager.Instance.Self.consortiaInfo.SmithLevel = _loc3_;
                  break;
               case 5:
                  PlayerManager.Instance.Self.consortiaInfo.BufferLevel = _loc3_;
            }
         }
      }
      
      private function __oncharmanChange(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = param1.pkg.readUTF();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         var _loc4_:String = param1.pkg.readUTF();
         MessageTipManager.getInstance().show(_loc4_);
      }
      
      private function __consortiaUserUpGrade(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         var _loc4_:Boolean = param1.pkg.readBoolean();
         var _loc5_:String = param1.pkg.readUTF();
         if(_loc3_)
         {
            if(_loc4_)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.upsuccess"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.upfalse"));
            }
         }
         else if(_loc4_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.downsuccess"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.downfalse"));
         }
      }
      
      private function __consortiaDescriptionUpdate(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = param1.pkg.readUTF();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         var _loc4_:String = param1.pkg.readUTF();
         MessageTipManager.getInstance().show(_loc4_);
         if(_loc3_)
         {
            PlayerManager.Instance.Self.consortiaInfo.Description = _loc2_;
         }
      }
      
      private function __skillChangehandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Date = null;
         var _loc7_:int = 0;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.pkg.readInt();
            _loc5_ = param1.pkg.readBoolean();
            _loc6_ = param1.pkg.readDate();
            _loc7_ = param1.pkg.readInt();
            this._model.updateSkillInfo(_loc4_,_loc5_,_loc6_,_loc7_);
            _loc3_++;
         }
         if(_loc2_ > 0)
         {
            this.getConsortionList(this.selfConsortionComplete,1,6,PlayerManager.Instance.Self.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
         }
         dispatchEvent(new ConsortionEvent(ConsortionEvent.SKILL_STATE_CHANGE));
      }
      
      private function __consortiaMailMessage(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = param1.pkg.readUTF();
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),"",false,true,true,LayerManager.BLCAK_BLOCKGOUND);
         _loc3_.moveEnable = false;
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__quitConsortiaResponse);
      }
      
      private function __quitConsortiaResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__quitConsortiaResponse);
         _loc2_.dispose();
         _loc2_ = null;
      }
      
      private function setPlayerConsortia(param1:uint = 0, param2:String = "") : void
      {
         PlayerManager.Instance.Self.ConsortiaName = param2;
         PlayerManager.Instance.Self.ConsortiaID = param1;
         if(param1 == 0)
         {
            PlayerManager.Instance.Self.consortiaInfo.Level = 0;
         }
      }
      
      public function memberListComplete(param1:ConsortionMemberAnalyer) : void
      {
         this._model.memberList = param1.consortionMember;
         TaskManager.onGuildUpdate();
      }
      
      public function clubSearchConsortions(param1:ConsortionListAnalyzer) : void
      {
         this._model.consortionList = param1.consortionList;
         this._model.consortionsListTotalCount = Math.ceil(param1.consortionsTotalCount / ConsortionModel.ConsortionListEachPageNum);
      }
      
      public function selfConsortionComplete(param1:ConsortionListAnalyzer) : void
      {
         if(param1.consortionList.length > 0)
         {
            PlayerManager.Instance.Self.consortiaInfo = param1.consortionList[0] as ConsortiaInfo;
         }
      }
      
      public function applyListComplete(param1:ConsortionApplyListAnalyzer) : void
      {
         this._model.myApplyList = param1.applyList;
         this._model.applyListTotalCount = param1.totalCount;
      }
      
      public function InventListComplete(param1:ConsortionInventListAnalyzer) : void
      {
         this._model.inventList = param1.inventList;
         this._model.inventListTotalCount = param1.totalCount;
      }
      
      private function levelUpInfoComplete(param1:ConsortionLevelUpAnalyzer) : void
      {
         this._model.levelUpData = param1.levelUpData;
      }
      
      public function eventListComplete(param1:ConsortionEventListAnalyzer) : void
      {
         this._model.eventList = param1.eventList;
      }
      
      public function useConditionListComplete(param1:ConsortionBuildingUseConditionAnalyer) : void
      {
         this._model.useConditionList = param1.useConditionList;
      }
      
      public function dutyListComplete(param1:ConsortionDutyListAnalyzer) : void
      {
         this._model.dutyList = param1.dutyList;
      }
      
      public function pollListComplete(param1:ConsortionPollListAnalyzer) : void
      {
         this._model.pollList = param1.pollList;
      }
      
      public function skillInfoListComplete(param1:ConsortionSkillInfoAnalyzer) : void
      {
         this._model.skillInfoList = param1.skillInfoList;
      }
      
      public function getConsortionList(param1:Function, param2:int = 1, param3:int = 6, param4:String = "", param5:int = -1, param6:int = -1, param7:int = -1, param8:int = -1) : void
      {
         var _loc9_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc9_["page"] = param2;
         _loc9_["size"] = param3;
         _loc9_["name"] = param4;
         _loc9_["level"] = param7;
         _loc9_["ConsortiaID"] = param8;
         _loc9_["order"] = param5;
         _loc9_["openApply"] = param6;
         var _loc10_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaList.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,_loc9_);
         _loc10_.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadMyconsortiaListError");
         _loc10_.analyzer = new ConsortionListAnalyzer(param1);
         _loc10_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc10_);
      }
      
      public function getApplyRecordList(param1:Function, param2:int = -1, param3:int = -1) : void
      {
         var _loc4_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc4_["page"] = 1;
         _loc4_["size"] = 1000;
         _loc4_["order"] = -1;
         _loc4_["consortiaID"] = param3;
         _loc4_["applyID"] = -1;
         _loc4_["userID"] = param2;
         _loc4_["userLevel"] = -1;
         var _loc5_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaApplyUsersList.ashx"),BaseLoader.REQUEST_LOADER,_loc4_);
         _loc5_.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadApplyRecordError");
         _loc5_.analyzer = new ConsortionApplyListAnalyzer(param1);
         _loc5_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc5_);
      }
      
      public function getInviteRecordList(param1:Function) : void
      {
         var _loc2_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc2_["page"] = 1;
         _loc2_["size"] = 1000;
         _loc2_["order"] = -1;
         _loc2_["userID"] = PlayerManager.Instance.Self.ID;
         _loc2_["inviteID"] = -1;
         var _loc3_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaInviteUsersList.ashx"),BaseLoader.REQUEST_LOADER,_loc2_);
         _loc3_.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadApplyRecordError");
         _loc3_.analyzer = new ConsortionInventListAnalyzer(param1);
         _loc3_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc3_);
      }
      
      public function getConsortionMember(param1:Function = null) : void
      {
         var _loc2_:URLVariables = null;
         var _loc3_:BaseLoader = null;
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            this._model.memberList.clear();
         }
         else
         {
            _loc2_ = RequestVairableCreater.creatWidthKey(true);
            _loc2_["page"] = 1;
            _loc2_["size"] = 10000;
            _loc2_["order"] = -1;
            _loc2_["consortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
            _loc2_["userID"] = -1;
            _loc2_["state"] = -1;
            _loc2_["rnd"] = Math.random();
            _loc3_ = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaUsersList.ashx"),BaseLoader.REQUEST_LOADER,_loc2_);
            _loc3_.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadMemberInfoError");
            _loc3_.analyzer = new ConsortionMemberAnalyer(param1);
            _loc3_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
            LoaderManager.Instance.startLoad(_loc3_);
         }
      }
      
      public function getLevelUpInfo() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaLevelList.xml"),BaseLoader.COMPRESS_REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadMyconsortiaLevelError");
         _loc2_.analyzer = new ConsortionLevelUpAnalyzer(this.levelUpInfoComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function loadEventList(param1:Function, param2:int = -1) : void
      {
         var _loc3_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc3_["page"] = 1;
         _loc3_["size"] = 50;
         _loc3_["order"] = -1;
         _loc3_["consortiaID"] = param2;
         var _loc4_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaEventList.ashx"),BaseLoader.REQUEST_LOADER,_loc3_);
         _loc4_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.consortion.loadEventList.fail");
         _loc4_.analyzer = new ConsortionEventListAnalyzer(param1);
         _loc4_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc4_);
      }
      
      public function loadUseConditionList(param1:Function, param2:int = -1) : void
      {
         var _loc3_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc3_["consortiaID"] = param2;
         _loc3_["level"] = -1;
         _loc3_["type"] = -1;
         var _loc4_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaEquipControlList.ashx"),BaseLoader.REQUEST_LOADER,_loc3_);
         _loc4_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.consortion.loadUseCondition.fail");
         _loc4_.analyzer = new ConsortionBuildingUseConditionAnalyer(param1);
         _loc4_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc4_);
      }
      
      public function loadDutyList(param1:Function, param2:int = -1, param3:int = -1) : void
      {
         var _loc4_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc4_["page"] = 1;
         _loc4_["size"] = 1000;
         _loc4_["ConsortiaID"] = param2;
         _loc4_["order"] = -1;
         _loc4_["dutyID"] = param3;
         var _loc5_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaDutyList.ashx"),BaseLoader.REQUEST_LOADER,_loc4_);
         _loc5_.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadDutyListError");
         _loc5_.analyzer = new ConsortionDutyListAnalyzer(param1);
         _loc5_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc5_);
      }
      
      public function loadPollList(param1:int) : void
      {
         var _loc2_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc2_["ConsortiaID"] = param1;
         var _loc3_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaCandidateList.ashx"),BaseLoader.REQUEST_LOADER,_loc2_);
         _loc3_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.consortion.pollload.error");
         _loc3_.analyzer = new ConsortionPollListAnalyzer(this.pollListComplete);
         _loc3_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc3_);
      }
      
      public function loadSkillInfoList() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaBufferTemp.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.consortion.skillInfo.loadError");
         _loc1_.analyzer = new ConsortionSkillInfoAnalyzer(this.skillInfoListComplete);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(param1.loader.analyzer)
         {
            _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),param1.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      private function __buyBadgeHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc8_:BadgeInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:Date = _loc2_.readDate();
         var _loc7_:Boolean = _loc2_.readBoolean();
         if(_loc3_ == PlayerManager.Instance.Self.ConsortiaID)
         {
            PlayerManager.Instance.Self.consortiaInfo.BadgeBuyTime = DateUtils.dateFormat(_loc6_);
            PlayerManager.Instance.Self.consortiaInfo.BadgeID = _loc4_;
            PlayerManager.Instance.Self.consortiaInfo.ValidDate = _loc5_;
            PlayerManager.Instance.Self.badgeID = _loc4_;
            _loc8_ = BadgeInfoManager.instance.getBadgeInfoByID(_loc4_);
            PlayerManager.Instance.Self.consortiaInfo.Riches -= _loc8_.Cost;
         }
      }
      
      public function alertTaxFrame() : void
      {
         var _loc1_:TaxFrame = ComponentFactory.Instance.creatComponentByStylename("taxFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function alertManagerFrame() : void
      {
         var _loc1_:ManagerFrame = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.loadUseConditionList(this.useConditionListComplete,PlayerManager.Instance.Self.ConsortiaID);
      }
      
      public function alertShopFrame() : void
      {
         var _loc1_:ConsortionShopFrame = ComponentFactory.Instance.creatComponentByStylename("consortionShopFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.loadUseConditionList(this.useConditionListComplete,PlayerManager.Instance.Self.ConsortiaID);
      }
      
      public function alertBankFrame() : void
      {
         var _loc1_:ConsortionBankFrame = ComponentFactory.Instance.creatComponentByStylename("consortionBankFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function alertTakeInFrame() : void
      {
         var _loc1_:TakeInMemberFrame = ComponentFactory.Instance.creatComponentByStylename("takeInMemberFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.getApplyRecordList(this.applyListComplete,-1,PlayerManager.Instance.Self.ConsortiaID);
      }
      
      public function alertQuitFrame() : void
      {
         var _loc1_:ConsortionQuitFrame = ComponentFactory.Instance.creatComponentByStylename("consortionQuitFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
	  private var _consortionBankFrame:ConsortionBankFrame;
	  public function hideBankFrame() : void
	  {
		  _consortionBankFrame = ComponentFactory.Instance.creatComponentByStylename("consortionBankFrame");
		  ObjectUtils.disposeObject(this._consortionBankFrame);
		  this._consortionBankFrame = null;
	  }
   }
}

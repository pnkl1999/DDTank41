package lanternriddles.view
{
	import baglocked.BaglockedManager;
	import com.pickgliss.events.FrameEvent;
	import com.pickgliss.ui.AlertManager;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.LayerManager;
	import com.pickgliss.ui.controls.BaseButton;
	import com.pickgliss.ui.controls.Frame;
	import com.pickgliss.ui.controls.alert.BaseAlerFrame;
	import com.pickgliss.ui.text.FilterFrameText;
	import com.pickgliss.utils.ObjectUtils;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.LeavePageManager;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;
	import ddt.manager.SocketManager;
	import ddt.manager.SoundManager;
	import ddt.utils.PositionUtils;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import lanternriddles.LanternRiddlesManager;
	import lanternriddles.data.LanternAwardInfo;
	import lanternriddles.data.LanternInfo;
	import lanternriddles.event.LanternEvent;
	import road7th.comm.PackageIn;
	
	public class LanternRiddlesView extends Frame
	{
		
		private static var RANK_NUM:int = 8;
		
		
		private var _bg:Bitmap;
		
		private var _questionView:QuestionView;
		
		private var _doubleBtn:BaseButton;
		
		private var _hitBtn:BaseButton;
		
		private var _freeDouble:FilterFrameText;
		
		private var _freeHit:FilterFrameText;
		
		private var _careInfo:FilterFrameText;
		
		private var _questionNum:FilterFrameText;
		
		private var _myRank:FilterFrameText;
		
		private var _myInteger:FilterFrameText;
		
		private var _rankVec:Vector.<LanternRankItem>;
		
		private var _offY:int = 40;
		
		private var _doubleFreeCount:int;
		
		private var _hitFreeCount:int;
		
		private var _doublePrice:int;
		
		private var _hitPrice:int;
		
		private var _hitFlag:Boolean;
		
		private var _alertAsk:LanternAlertView;
		
		public function LanternRiddlesView()
		{
			super();
			initView();
			initEvent();
			sendPkg();
		}
		
		private function initView() : void
		{
			titleText = LanguageMgr.GetTranslation("lanternRiddles.view.Title");
			_bg = ComponentFactory.Instance.creat("lantern.view.bg");
			addToContent(_bg);
			_questionView = new QuestionView();
			addToContent(_questionView);
			_doubleBtn = ComponentFactory.Instance.creat("lantern.view.doubleBtn");
			addToContent(_doubleBtn);
			_freeDouble = ComponentFactory.Instance.creatComponentByStylename("lantern.view.freeDouble");
			_doubleBtn.addChild(_freeDouble);
			_hitBtn = ComponentFactory.Instance.creat("lantern.view.hitBtn");
			addToContent(_hitBtn);
			_freeHit = ComponentFactory.Instance.creatComponentByStylename("lantern.view.freeHit");
			_hitBtn.addChild(_freeHit);
			_careInfo = ComponentFactory.Instance.creatComponentByStylename("lantern.view.careInfo");
			_careInfo.text = LanguageMgr.GetTranslation("lanternRiddles.view.careInfoText");
			addToContent(_careInfo);
			_questionNum = ComponentFactory.Instance.creatComponentByStylename("lantern.view.questionNum");
			addToContent(_questionNum);
			_myRank = ComponentFactory.Instance.creatComponentByStylename("lantern.view.rank");
			addToContent(_myRank);
			_myInteger = ComponentFactory.Instance.creatComponentByStylename("lantern.view.integer");
			addToContent(_myInteger);
			_rankVec = new Vector.<LanternRankItem>();
			addRankView();
		}
		
		private function addRankView() : void
		{
			var _loc1_:* = null;
			var _loc2_:int = 0;
			_loc2_ = 0;
			while(_loc2_ < RANK_NUM)
			{
				_loc1_ = new LanternRankItem();
				_loc1_.buttonMode = true;
				PositionUtils.setPos(_loc1_,"lantern.view.rankPos");
				_loc1_.y += _loc2_ * _offY;
				addToContent(_loc1_);
				_rankVec.push(_loc1_);
				_loc2_++;
			}
		}
		
		private function initEvent() : void
		{
			addEventListener("response",__frameEventHandler);
			_doubleBtn.addEventListener("click",_onDoubleBtnClick);
			_hitBtn.addEventListener("click",__onHitBtnClick);
			LanternRiddlesManager.instance.addEventListener("lanternRiddles_question",__onSetQuestionInfo);
			LanternRiddlesManager.instance.addEventListener("lanternRiddles_rankinfo",__onSetRankInfo);
			LanternRiddlesManager.instance.addEventListener("lanternRiddles_skill",__onSetBtnEnable);
		}
		
		protected function __onSetBtnEnable(param1:CrazyTankSocketEvent) : void
		{
			var _loc3_:PackageIn = param1.pkg;
			var _loc2_:Boolean = _loc3_.readBoolean();
			if(_hitFlag)
			{
				_questionView.setSelectBtnEnable(false);
				_hitBtn.enable = !_loc2_;
			}
			else
			{
				_doubleBtn.enable = !_loc2_;
			}
		}
		
		protected function __onSetQuestionInfo(param1:CrazyTankSocketEvent) : void
		{
			var _loc8_:* = null;
			var _loc5_:int = 0;
			var _loc9_:int = 0;
			var _loc10_:int = 0;
			var _loc3_:Boolean = false;
			var _loc2_:Boolean = false;
			var _loc7_:PackageIn;
			var _loc4_:int = (_loc7_ = param1.pkg).readInt();
			var _loc6_:int = _loc7_.readInt();
			var _loc11_:LanternInfo;
			if(_loc11_ == LanternRiddlesManager.instance.info[_loc6_])
			{
				_questionView.count = _loc7_.readInt();
				_loc8_ = _loc7_.readDate();
				_doubleFreeCount = _loc7_.readInt();
				_doublePrice = _loc7_.readInt();
				_hitFreeCount = _loc7_.readInt();
				_hitPrice = _loc7_.readInt();
				_loc5_ = _loc7_.readInt();
				_loc9_ = _loc7_.readInt();
				_loc10_ = _loc7_.readInt();
				_loc3_ = _loc7_.readBoolean();
				_loc2_ = _loc7_.readBoolean();
				_loc11_.QuestionIndex = _loc4_;
				_loc11_.QuestionID = _loc6_;
				_loc11_.Option = _loc10_;
				_loc11_.EndDate = _loc8_;
				_questionView.setSelectBtnEnable(true);
				_questionView.info = _loc11_;
				_freeDouble.text = LanguageMgr.GetTranslation("lanternRiddles.view.freeText",_doubleFreeCount);
				_freeHit.text = LanguageMgr.GetTranslation("lanternRiddles.view.freeText",_hitFreeCount);
				_myInteger.text = _loc5_.toString();
				_questionNum.text = LanguageMgr.GetTranslation("lanternRiddles.view.questionNumText",_loc9_);
				if(_questionView.countDownTime > 0)
				{
					_doubleBtn.enable = !_loc2_;
					_hitBtn.enable = !_loc3_;
					if(!_hitBtn.enable)
					{
						_questionView.setSelectBtnEnable(false);
					}
				}
				else
				{
					_questionView.setSelectBtnEnable(false);
					_doubleBtn.enable = false;
					_hitBtn.enable = false;
				}
				SocketManager.Instance.out.sendLanternRiddlesRankInfo();
				if(_alertAsk)
				{
					_alertAsk.dispose();
					_alertAsk = null;
				}
			}
		}
		
		protected function __onSetRankInfo(param1:CrazyTankSocketEvent) : void
		{
			var _loc10_:int = 0;
			var _loc9_:* = null;
			var _loc2_:int = 0;
			var _loc7_:int = 0;
			var _loc3_:* = null;
			var _loc6_:int = 0;
			var _loc5_:PackageIn = param1.pkg;
			var _loc8_:Array = [];
			_myRank.text = String(_loc5_.readInt());
			var _loc4_:int = _loc5_.readInt();
			_loc10_ = 0;
			while(_loc10_ < _loc4_)
			{
				(_loc9_ = new LanternInfo()).Rank = _loc5_.readInt();
				_loc9_.NickName = _loc5_.readUTF();
				_loc9_.TypeVIP = _loc5_.readByte();
				_loc9_.Integer = _loc5_.readInt();
				_loc2_ = _loc5_.readInt();
				_loc7_ = 0;
				while(_loc7_ < _loc2_)
				{
					_loc3_ = new LanternAwardInfo();
					_loc3_.TempId = _loc5_.readInt();
					_loc3_.AwardNum = _loc5_.readInt();
					_loc3_.IsBind = _loc5_.readBoolean();
					_loc3_.ValidDate = _loc5_.readInt();
					_loc9_.AwardInfoVec.push(_loc3_);
					_loc7_++;
				}
				_loc8_.push(_loc9_);
				_loc10_++;
			}
			_loc8_.sortOn("Rank",16);
			_loc6_ = 0;
			while(_loc6_ < _loc8_.length)
			{
				_rankVec[_loc6_].info = _loc8_[_loc6_];
				_loc6_++;
			}
		}
		
		protected function _onDoubleBtnClick(param1:MouseEvent) : void
		{
			SoundManager.instance.playButtonSound();
			_hitFlag = false;
			if(_doubleFreeCount <= 0)
			{
				if(!SharedManager.Instance.isBuyInteger)
				{
					if(PlayerManager.Instance.Self.bagLocked)
					{
						BaglockedManager.Instance.show();
						return;
					}
					_alertAsk = ComponentFactory.Instance.creatComponentByStylename("lantern.view.alertView");
					_alertAsk.text = LanguageMgr.GetTranslation("lanternRiddles.view.buyDoubleInteger.alertInfo",_doublePrice);
					LayerManager.Instance.addToLayer(_alertAsk,3,true,1);
					_alertAsk.addEventListener("lanternSelect",__onLanternAlertSelect);
					_alertAsk.addEventListener("response",__onBuyHandle);
				}
				else if(payment(SharedManager.Instance.isBuyIntegerBind))
				{
					SocketManager.Instance.out.sendLanternRiddlesUseSkill(_questionView.info.QuestionID,_questionView.info.QuestionIndex,1,SharedManager.Instance.isBuyIntegerBind);
				}
			}
			else if(!_hitBtn.enable || _questionView.info.Option != 0)
			{
				SocketManager.Instance.out.sendLanternRiddlesUseSkill(_questionView.info.QuestionID,_questionView.info.QuestionIndex,1);
			}
			else
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("lanternRiddles.view.doubleClick.tipsInfo"));
			}
		}
		
		protected function __onLanternAlertSelect(param1:LanternEvent) : void
		{
			setBindFlag(param1.flag);
		}
		
		protected function __onBuyHandle(param1:FrameEvent) : void
		{
			var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
			_loc2_.removeEventListener("lanternSelect",__onLanternAlertSelect);
			_loc2_.removeEventListener("response",__onBuyHandle);
			switch(int(param1.responseCode) - 2)
			{
				case 0:
				case 1:
					if(_hitFlag)
					{
						SharedManager.Instance.isBuyHitBind = _loc2_.isBand;
					}
					else
					{
						SharedManager.Instance.isBuyIntegerBind = _loc2_.isBand;
					}
					if(payment(_loc2_.isBand))
					{
						SocketManager.Instance.out.sendLanternRiddlesUseSkill(_questionView.info.QuestionID,_questionView.info.QuestionIndex,!!_hitFlag ? 0 : 1,_loc2_.isBand);
					}
					_hitBtn.enable = false;
					break;
				default:
					setBindFlag(false);
			}
			_loc2_.dispose();
			_loc2_ = null;
		}
		
		private function setBindFlag(param1:Boolean) : void
		{
			if(_hitFlag)
			{
				SharedManager.Instance.isBuyHit = param1;
			}
			else
			{
				SharedManager.Instance.isBuyInteger = param1;
			}
		}
		
		private function payment(param1:Boolean) : Boolean
		{
			var _loc2_:* = null;
			if(param1)
			{
				if(!checkMoney(true))
				{
					_loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
					_loc2_.addEventListener("response",onResponseHander);
					return false;
				}
			}
			else if(!checkMoney(false))
			{
				_loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,2);
				_loc2_.addEventListener("response",_response);
				return false;
			}
			return true;
		}
		
		protected function __onHitBtnClick(param1:MouseEvent) : void
		{
			SoundManager.instance.playButtonSound();
			_hitFlag = true;
			if(_hitFreeCount <= 0)
			{
				if(!SharedManager.Instance.isBuyHit)
				{
					if(PlayerManager.Instance.Self.bagLocked)
					{
						BaglockedManager.Instance.show();
						return;
					}
					_alertAsk = ComponentFactory.Instance.creatComponentByStylename("lantern.view.alertView");
					_alertAsk.text = LanguageMgr.GetTranslation("lanternRiddles.view.buyHit.alertInfo",_hitPrice);
					LayerManager.Instance.addToLayer(_alertAsk,3,true,1);
					_alertAsk.addEventListener("lanternSelect",__onLanternAlertSelect);
					_alertAsk.addEventListener("response",__onBuyHandle);
				}
				else
				{
					if(payment(SharedManager.Instance.isBuyHitBind))
					{
						SocketManager.Instance.out.sendLanternRiddlesUseSkill(_questionView.info.QuestionID,_questionView.info.QuestionIndex,0,SharedManager.Instance.isBuyHitBind);
					}
					_hitBtn.enable = false;
				}
			}
			else
			{
				SocketManager.Instance.out.sendLanternRiddlesUseSkill(_questionView.info.QuestionID,_questionView.info.QuestionIndex,0);
				_hitBtn.enable = false;
			}
		}
		
		private function sendPkg() : void
		{
			SocketManager.Instance.out.sendLanternRiddlesQuestion();
		}
		
		public function show() : void
		{
			LayerManager.Instance.addToLayer(this,3,true,2);
		}
		
		private function removeEvent() : void
		{
			removeEventListener("response",__frameEventHandler);
			_doubleBtn.removeEventListener("click",_onDoubleBtnClick);
			_hitBtn.removeEventListener("click",__onHitBtnClick);
			LanternRiddlesManager.instance.removeEventListener("lanternRiddles_question",__onSetQuestionInfo);
			LanternRiddlesManager.instance.removeEventListener("lanternRiddles_rankinfo",__onSetRankInfo);
			LanternRiddlesManager.instance.removeEventListener("lanternRiddles_skill",__onSetBtnEnable);
		}
		
		private function __frameEventHandler(param1:FrameEvent) : void
		{
			SoundManager.instance.play("008");
			switch(param1.responseCode)
			{
				case FrameEvent.ESC_CLICK:
				case FrameEvent.CLOSE_CLICK:
					LanternRiddlesManager.instance.hide();
			}
		}
		
		private function onResponseHander(param1:FrameEvent) : void
		{
			var _loc2_:* = null;
			(param1.currentTarget as BaseAlerFrame).removeEventListener("response",onResponseHander);
			if(param1.responseCode == 2 || param1.responseCode == 3)
			{
				if(!checkMoney(false))
				{
					_loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,2);
					_loc2_.addEventListener("response",_response);
					return;
				}
				SocketManager.Instance.out.sendLanternRiddlesUseSkill(_questionView.info.QuestionID,_questionView.info.QuestionIndex,!!_hitFlag ? 0 : 1,false);
			}
			param1.currentTarget.dispose();
		}
		
		private function _response(param1:FrameEvent) : void
		{
			(param1.currentTarget as BaseAlerFrame).removeEventListener("response",_response);
			if(param1.responseCode == 3 || param1.responseCode == 2)
			{
				LeavePageManager.leaveToFillPath();
			}
			ObjectUtils.disposeObject(param1.currentTarget);
		}
		
		private function checkMoney(param1:Boolean) : Boolean
		{
			var _loc2_:int = !!_hitFlag ? _hitPrice : int(_doublePrice);
			if(param1)
			{
				if(PlayerManager.Instance.Self.Gift < _loc2_)
				{
					return false;
				}
			}
			else if(PlayerManager.Instance.Self.Money < _loc2_)
			{
				return false;
			}
			return true;
		}
		
		override public function dispose() : void
		{
			var _loc1_:int = 0;
			super.dispose();
			removeEvent();
			if(_bg)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			if(_questionView)
			{
				_questionView.dispose();
				_questionView = null;
			}
			if(_doubleBtn)
			{
				_doubleBtn.dispose();
				_doubleBtn = null;
			}
			if(_hitBtn)
			{
				_hitBtn.dispose();
				_hitBtn = null;
			}
			if(_freeDouble)
			{
				_freeDouble.dispose();
				_freeDouble = null;
			}
			if(_freeHit)
			{
				_freeHit.dispose();
				_freeHit = null;
			}
			if(_careInfo)
			{
				_careInfo.dispose();
				_careInfo = null;
			}
			if(_myRank)
			{
				_myRank.dispose();
				_myRank = null;
			}
			if(_myInteger)
			{
				_myInteger.dispose();
				_myInteger = null;
			}
			if(_rankVec)
			{
				_loc1_ = 0;
				while(_loc1_ < _rankVec.length)
				{
					_rankVec[_loc1_].dispose();
					_rankVec[_loc1_] = null;
					_loc1_++;
				}
				_rankVec.length = 0;
				_rankVec = null;
			}
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
	}
}

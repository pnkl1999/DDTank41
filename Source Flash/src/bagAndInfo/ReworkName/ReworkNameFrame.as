package bagAndInfo.ReworkName
{
	import com.pickgliss.events.FrameEvent;
	import com.pickgliss.loader.BaseLoader;
	import com.pickgliss.loader.LoaderEvent;
	import com.pickgliss.loader.LoaderManager;
	import com.pickgliss.toplevel.StageReferance;
	import com.pickgliss.ui.AlertManager;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.controls.BaseButton;
	import com.pickgliss.ui.controls.Frame;
	import com.pickgliss.ui.controls.TextButton;
	import com.pickgliss.ui.controls.alert.BaseAlerFrame;
	import com.pickgliss.ui.text.FilterFrameText;
	import com.pickgliss.utils.ObjectUtils;
	import ddt.data.analyze.ReworkNameAnalyzer;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.SoundManager;
	import ddt.utils.FilterWordManager;
	import ddt.utils.RequestVairableCreater;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	public class ReworkNameFrame extends Frame
	{
		
		public static const Close:String = "close";
		
		public static const ReworkDone:String = "ReworkDone";
		
		public static const Aviable:String = "aviable";
		
		public static const Unavialbe:String = "unaviable";
		
		public static const Input:String = "input";
		
		
		protected var _tittleField:FilterFrameText;
		
		protected var _nicknameInput:FilterFrameText;
		
		protected var _inputBackground:Bitmap;
		
		protected var _resultField:FilterFrameText;
		
		protected var _checkButton:BaseButton;
		
		protected var _submitButton:TextButton;
		
		protected var _available:Boolean = true;
		
		protected var _nicknameDetail:String;
		
		private var _resultDefaultFormat:TextFormat;
		
		private var _avialableFormat:TextFormat;
		
		private var _unAviableFormat:TextFormat;
		
		private var _disEnabledFilters:Array;
		
		private var _complete:Boolean = true;
		
		protected var _path:String = "NickNameCheck.ashx";
		
		protected var _bagType:int;
		
		protected var _place:int;
		
		protected var _maxChars:int;
		
		protected var _state:String;
		
		protected var _isCanRework:Boolean;
		
		public function ReworkNameFrame()
		{
			_nicknameDetail = LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.check_txt");
			_disEnabledFilters = [ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ButtonDisenable")];
			super();
			escEnable = true;
			enterEnable = true;
			configUi();
			addEvent();
		}
		
		protected function configUi() : void
		{
			titleText = LanguageMgr.GetTranslation("tank.view.ReworkNameView.reworkName");
			_resultDefaultFormat = ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ResultDefaultTF");
			_avialableFormat = ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ResultAvailableTF");
			_unAviableFormat = ComponentFactory.Instance.model.getSet("bagAndInfo.reworkname.ResultUnAvailableTF");
			_inputBackground = ComponentFactory.Instance.creatBitmap("bagAndInfo.reworkname.backgound_input");
			addToContent(_inputBackground);
			_tittleField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.ReworkNameTittle");
			_tittleField.text = LanguageMgr.GetTranslation("tank.view.ReworkNameView.inputName");
			addToContent(_tittleField);
			_resultField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.ReworkNameCheckResult");
			_resultField.defaultTextFormat = _resultDefaultFormat;
			_resultField.text = _nicknameDetail;
			addToContent(_resultField);
			_nicknameInput = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.NicknameInput");
			addToContent(_nicknameInput);
			_checkButton = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.CheckButton");
			addToContent(_checkButton);
			_submitButton = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.SubmitButton");
			_submitButton.text = LanguageMgr.GetTranslation("tank.view.ReworkNameView.okLabel");
			addToContent(_submitButton);
			_submitButton.enable = false;
			_submitButton.filters = _disEnabledFilters;
		}
		
		private function addEvent() : void
		{
			_nicknameInput.addEventListener("change",__onInputChange);
			_checkButton.addEventListener("click",__onCheckClick);
			_submitButton.addEventListener("click",__onSubmitClick);
			addEventListener("response",__onResponse);
			addEventListener("addedToStage",__onToStage);
		}
		
		private function removeEvent() : void
		{
			_nicknameInput.removeEventListener("change",__onInputChange);
			_checkButton.removeEventListener("click",__onCheckClick);
			_submitButton.removeEventListener("click",__onSubmitClick);
			removeEventListener("response",__onResponse);
			removeEventListener("addedToStage",__onToStage);
		}
		
		private function __onToStage(param1:Event) : void
		{
			removeEventListener("addedToStage",__onToStage);
			StageReferance.stage.focus = _nicknameInput;
			setTimeout(_nicknameInput.setFocus,100);
		}
		
		private function __onResponse(param1:FrameEvent) : void
		{
			SoundManager.instance.play("008");
			switch(int(param1.responseCode))
			{
				case 0:
				case 1:
				case 4:
					close();
					break;
				case 2:
				case 3:
					if(_submitButton.enable)
					{
						__onSubmitClick(null);
						break;
					}
			}
		}
		
		protected function __onInputChange(param1:Event) : void
		{
			state = "input";
			if(state != "input")
			{
				state = "input";
			}
			if(!_nicknameInput.text || _nicknameInput.text == "")
			{
				_submitButton.enable = false;
				_submitButton.filters = _disEnabledFilters;
			}
			else
			{
				_submitButton.enable = true;
				_submitButton.filters = null;
			}
		}
		
		protected function __onCheckClick(param1:MouseEvent) : void
		{
			if(complete)
			{
				SoundManager.instance.play("008");
				_isCanRework = false;
				if(nameInputCheck())
				{
					createCheckLoader(checkNameCallBack);
				}
				else
				{
					visibleCheckText();
				}
			}
		}
		
		protected function visibleCheckText() : void
		{
			state = "input";
			_resultField.text = _nicknameDetail;
		}
		
		private function __onSubmitClick(param1:MouseEvent) : void
		{
			if(complete)
			{
				SoundManager.instance.play("008");
				_isCanRework = false;
				if(_nicknameInput.text == "")
				{
					setCheckTxt(LanguageMgr.GetTranslation("tank.view.ReworkNameView.inputName"));
				}
				if(!nameInputCheck())
				{
					visibleCheckText();
					return;
				}
				createCheckLoader(submitCheckCallBack);
			}
		}
		
		protected function setCheckTxt(param1:String) : void
		{
			if(param1 == LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.setCheckTxt"))
			{
				state = "aviable";
				_isCanRework = true;
			}
			else
			{
				state = "unaviable";
			}
			_resultField.text = param1;
		}
		
		private function __onLoadError(param1:LoaderEvent) : void
		{
			complete = true;
			state = "unaviable";
			param1.loader.removeEventListener("loadError",__onLoadError);
		}
		
		protected function createCheckLoader(param1:Function) : BaseLoader
		{
			var _loc3_:URLVariables = RequestVairableCreater.creatWidthKey(true);
			_loc3_["id"] = PlayerManager.Instance.Self.ID;
			_loc3_["bagType"] = _bagType;
			_loc3_["place"] = _place;
			_loc3_["NickName"] = _nicknameInput.text;
			var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath(_path),6,_loc3_);
			_loc2_.loadErrorMessage = LanguageMgr.GetTranslation("choosecharacter.LoadCheckName.m");
			_loc2_.analyzer = new ReworkNameAnalyzer(param1);
			_loc2_.addEventListener("loadError",__onLoadError);
			LoaderManager.Instance.startLoad(_loc2_);
			complete = false;
			return _loc2_;
		}
		
		protected function checkNameCallBack(param1:ReworkNameAnalyzer) : void
		{
			complete = true;
			var _loc2_:XML = param1.result;
			setCheckTxt(_loc2_.@message);
		}
		
		protected function reworkNameComplete() : void
		{
			complete = true;
			SoundManager.instance.play("047");
			var _loc1_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.ReworkNameView.reworkNameComplete"),LanguageMgr.GetTranslation("ok"));
			_loc1_.addEventListener("response",__onAlertResponse);
			close();
		}
		
		protected function __onAlertResponse(param1:FrameEvent) : void
		{
			SoundManager.instance.play("008");
			var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
			_loc2_.removeEventListener("response",__onAlertResponse);
			switch(int(param1.responseCode))
			{
				case 0:
				case 1:
				case 2:
				case 3:
				case 4:
					_loc2_.dispose();
			}
			StageReferance.stage.focus = _nicknameInput;
		}
		
		protected function submitCheckCallBack(param1:ReworkNameAnalyzer) : void
		{
			var _loc3_:* = null;
			complete = true;
			var _loc2_:XML = param1.result;
			setCheckTxt(_loc2_.@message);
			if(nameInputCheck() && _isCanRework)
			{
				_loc3_ = _nicknameInput.text;
				SocketManager.Instance.out.sendUseReworkName(_bagType,_place,_loc3_);
				reworkNameComplete();
			}
		}
		
		protected function __onFrameResponse(param1:FrameEvent) : void
		{
			var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
			_loc2_.removeEventListener("response",__onFrameResponse);
			_loc2_.dispose();
			state = "input";
		}
		
		protected function nameInputCheck() : Boolean
		{
			var _loc1_:* = null;
			if(_nicknameInput.text != "")
			{
				if(FilterWordManager.isGotForbiddenWords(_nicknameInput.text,"name"))
				{
					_loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.name"),LanguageMgr.GetTranslation("ok"),"",false,false,false,2);
					_loc1_.addEventListener("response",__onAlertResponse);
					return false;
				}
				if(FilterWordManager.IsNullorEmpty(_nicknameInput.text))
				{
					_loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.space"),LanguageMgr.GetTranslation("ok"),"",false,false,false,2);
					_loc1_.addEventListener("response",__onAlertResponse);
					return false;
				}
				if(FilterWordManager.containUnableChar(_nicknameInput.text))
				{
					_loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.string"),LanguageMgr.GetTranslation("ok"),"",false,false,false,2);
					_loc1_.addEventListener("response",__onAlertResponse);
					return false;
				}
				return true;
			}
			_loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.input"),LanguageMgr.GetTranslation("ok"),"",false,false,false,2);
			_loc1_.addEventListener("response",__onAlertResponse);
			return false;
		}
		
		public function initialize(param1:int, param2:int) : void
		{
			_bagType = param1;
			_place = param2;
		}
		
		public function get state() : String
		{
			return _state;
		}
		
		public function set state(param1:String) : void
		{
			if(_state != param1)
			{
				_state = param1;
				if(_state == "aviable")
				{
					_resultField.defaultTextFormat = _avialableFormat;
					_resultField.setTextFormat(_avialableFormat,0,_resultField.length);
				}
				else if(_state == "unaviable")
				{
					_resultField.defaultTextFormat = _unAviableFormat;
					_resultField.setTextFormat(_unAviableFormat,0,_resultField.length);
				}
				else
				{
					_resultField.defaultTextFormat = _resultDefaultFormat;
					_resultField.setTextFormat(_resultDefaultFormat,0,_resultField.length);
					_resultField.text = _nicknameDetail;
					_isCanRework = true;
				}
			}
		}
		
		public function get complete() : Boolean
		{
			return _complete;
		}
		
		public function set complete(param1:Boolean) : void
		{
			if(_complete != param1)
			{
				_complete = param1;
				if(_complete)
				{
					if(!_nicknameInput.text || _nicknameInput.text == "")
					{
						_submitButton.enable = false;
						_submitButton.filters = _disEnabledFilters;
					}
					else
					{
						_submitButton.enable = true;
						_submitButton.filters = null;
					}
				}
				else
				{
					_submitButton.enable = false;
					_submitButton.filters = _disEnabledFilters;
				}
			}
		}
		
		public function close() : void
		{
			dispatchEvent(new Event("complete"));
		}
		
		override public function dispose() : void
		{
			removeEvent();
			if(_tittleField)
			{
				ObjectUtils.disposeObject(_tittleField);
				_tittleField = null;
			}
			if(_resultField)
			{
				ObjectUtils.disposeObject(_resultField);
				_resultField = null;
			}
			if(_nicknameInput)
			{
				ObjectUtils.disposeObject(_nicknameInput);
				_nicknameInput = null;
			}
			if(_checkButton)
			{
				ObjectUtils.disposeObject(_checkButton);
				_checkButton = null;
			}
			if(_submitButton)
			{
				ObjectUtils.disposeObject(_submitButton);
				_submitButton = null;
			}
			if(_inputBackground)
			{
				ObjectUtils.disposeObject(_inputBackground);
				_inputBackground = null;
			}
			_resultDefaultFormat = null;
			_avialableFormat = null;
			_disEnabledFilters = null;
			super.dispose();
		}
	}
}

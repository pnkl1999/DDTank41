package lanternriddles.view
{
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.controls.SelectedCheckButton;
	import com.pickgliss.ui.controls.alert.BaseAlerFrame;
	import com.pickgliss.ui.text.FilterFrameText;
	import com.pickgliss.ui.vo.AlertInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.SoundManager;
	import flash.events.Event;
	import lanternriddles.event.LanternEvent;
	
	public class LanternAlertView extends BaseAlerFrame
	{
		
		
		private var _tipInfo:FilterFrameText;
		
		private var _checkBtn:SelectedCheckButton;
		
		public function LanternAlertView()
		{
			super();
			info = new AlertInfo(LanguageMgr.GetTranslation("tips"));
			initView();
			initEvent();
		}
		
		private function initView() : void
		{
			_tipInfo = ComponentFactory.Instance.creatComponentByStylename("lantern.view.alertText");
			addToContent(_tipInfo);
			_checkBtn = ComponentFactory.Instance.creatComponentByStylename("lantern.view.selectBtn");
			_checkBtn.text = LanguageMgr.GetTranslation("ddt.farms.refreshPetsNOAlert");
			addToContent(_checkBtn);
		}
		
		private function initEvent() : void
		{
			_checkBtn.addEventListener("select",__noAlertTip);
		}
		
		public function get notShowAgain() : Boolean
		{
			return _checkBtn.selected;
		}
		
		protected function __noAlertTip(param1:Event) : void
		{
			SoundManager.instance.play("008");
			var _loc2_:LanternEvent = new LanternEvent("lanternSelect");
			_loc2_.flag = _checkBtn.selected;
			dispatchEvent(_loc2_);
		}
		
		public function set text(param1:String) : void
		{
			_tipInfo.text = param1;
		}
		
		private function removeEvent() : void
		{
			if(_checkBtn)
			{
				_checkBtn.removeEventListener("select",__noAlertTip);
			}
		}
		
		override public function dispose() : void
		{
			removeEvent();
			if(_tipInfo)
			{
				_tipInfo.dispose();
				_tipInfo = null;
			}
			if(_checkBtn)
			{
				_checkBtn.dispose();
				_checkBtn = null;
			}
			super.dispose();
		}
	}
}

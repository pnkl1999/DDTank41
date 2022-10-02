package ddt.manager
{
	
	import ddt.events.CrazyTankSocketEvent;
	import ddt.view.bossbox.TimeBoxEvent;
	import ddt.view.bossbox.TimeCountDown;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import road7th.comm.PackageIn;
	
	public class CheckSpeedManager extends EventDispatcher
	{
		private static var _instance:CheckSpeedManager;
		
		private var _time:TimeCountDown;
		
		private var minuscheck:Number = 5;
		
		private var _delaySumTime1:int = 0;
		
		public function CheckSpeedManager()
		{
			super();
			this.setup();
		}
		
		public static function get instance() : CheckSpeedManager
		{
			if(_instance == null)
			{
				_instance = new CheckSpeedManager();
			}
			return _instance;
		}
		
		private function init() : void
		{
			this._time = new TimeCountDown(1000);
		}
		
		private function initEvent() : void
		{
			this._time.addEventListener(TimeCountDown.COUNTDOWN_COMPLETE,this._timeOver);
			this._time.addEventListener(TimeCountDown.COUNTDOWN_ONE,this._timeOne);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BAOLTFUNCTION,this._getTimeCheck);
		}
		
		public function setup() : void
		{
			this.init();
			this.initEvent();
		}
		
		public function startDelayTime1() : void
		{
			//ConsoleLog.write("start");
			this.resetTime();
		}
		
		private function resetTime() : void
		{
			
			this._time.setTimeOnMinute(this.minuscheck);
			this.delaySumTime1 = this.minuscheck * 60;
			//ConsoleLog.write("this.delaySumTime1: " + this.delaySumTime1.toString());
			//ConsoleLog.write("set time");
		}
		
		private function removeEvent() : void
		{
			this._time.removeEventListener(TimeCountDown.COUNTDOWN_COMPLETE,this._timeOver);
			this._time.removeEventListener(TimeCountDown.COUNTDOWN_ONE,this._timeOne);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BAOLTFUNCTION,this._getTimeCheck);
		}
		
		private function _getTimeCheck(evt:CrazyTankSocketEvent) : void
		{
			var pkg:PackageIn = evt.pkg;
			pkg.readInt();
			this.resetTime();
		}
		
		private function _timeOver(e:Event) : void
		{
			//hết giờ 
			SocketManager.Instance.out.sendpkgCheckHack();
			//ConsoleLog.write("hi");
		}
		
		private function _timeOne(e:Event) : void
		{
			this.delaySumTime1--;
		}
		
		public function set delaySumTime1(value:int) : void
		{
			this._delaySumTime1 = value;
			var evt:TimeBoxEvent = new TimeBoxEvent(TimeBoxEvent.UPDATETIMECOUNT);
			evt.delaySumTime = this._delaySumTime1;
			dispatchEvent(evt);
		}
		
		public function get delaySumTime1() : int
		{
			return this._delaySumTime1;
		}
		
	}
}
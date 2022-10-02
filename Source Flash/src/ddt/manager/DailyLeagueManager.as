package ddt.manager
{
	import com.pickgliss.loader.DataAnalyzer;
	import ddt.data.DailyLeagueAwardInfo;
	import ddt.data.DailyLeagueLevelInfo;
	import ddt.data.analyze.DailyLeagueAwardAnalyzer;
	import ddt.data.analyze.DailyLeagueLevelAnalyzer;
	import flash.events.EventDispatcher;
	
	public class DailyLeagueManager extends EventDispatcher
	{
		
		private static var _instance:DailyLeagueManager;
		
		private static const PLAYER_LEVEL:Array = [[20,29],[30,39],[40,49]];
		
		
		private var _leagueLevelRank:Array;
		
		private var _leagueAwardList:Array;
		
		private var _lv1:int;
		
		private var _lv2:int;
		
		private var _scoreLv:int;
		
		public function DailyLeagueManager()
		{
			super();
		}
		
		public static function get Instance() : DailyLeagueManager
		{
			if(_instance == null)
			{
				_instance = new DailyLeagueManager();
			}
			return _instance;
		}
		
		public function setup(_arg_1:DataAnalyzer) : void
		{
			if(_arg_1 is DailyLeagueAwardAnalyzer)
			{
				this._leagueAwardList = DailyLeagueAwardAnalyzer(_arg_1).list;
			}
			else if(_arg_1 is DailyLeagueLevelAnalyzer)
			{
				this._leagueLevelRank = DailyLeagueLevelAnalyzer(_arg_1).list;
			}
		}
		
		public function getLeagueLevelByScore(_arg_1:Number, _arg_2:Boolean = false) : DailyLeagueLevelInfo
		{
			var _local_4:int = 0;
			var _local_3:DailyLeagueLevelInfo = new DailyLeagueLevelInfo();
			if(_arg_2)
			{
				return this._leagueLevelRank[0];
			}
			while(_local_4 < this._leagueLevelRank.length)
			{
				if(this._leagueLevelRank[_local_4].Score > -1 && _arg_1 >= this._leagueLevelRank[_local_4].Score)
				{
					_local_3 = this._leagueLevelRank[_local_4];
				}
				_local_4++;
			}
			return _local_3;
		}
		
		public function filterLeagueAwardList(_arg_1:int, _arg_2:int) : Array
		{
			this._lv1 = PLAYER_LEVEL[_arg_1][0];
			this._lv2 = PLAYER_LEVEL[_arg_1][1];
			this._scoreLv = _arg_1 * 4 + (_arg_2 + 1);
			return this._leagueAwardList.filter(this.filterLeagueAwardListCallback);
		}
		
		private function filterLeagueAwardListCallback(_arg_1:DailyLeagueAwardInfo, _arg_2:int, _arg_3:Array) : Boolean
		{
			if(_arg_1.Level >= this._lv1 && _arg_1.Level <= this._lv2 && _arg_1.Class == this._scoreLv)
			{
				return true;
			}
			return false;
		}
	}
}

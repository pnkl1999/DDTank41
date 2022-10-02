package gotopage.view
{
	import com.pickgliss.events.FrameEvent;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.controls.Frame;
	import com.pickgliss.ui.controls.ScrollPanel;
	import com.pickgliss.ui.controls.SelectedButton;
	import com.pickgliss.ui.controls.SelectedButtonGroup;
	import com.pickgliss.ui.controls.SelectedTextButton;
	import com.pickgliss.ui.controls.container.SimpleTileList;
	import com.pickgliss.ui.image.MutipleImage;
	import com.pickgliss.ui.text.FilterFrameText;
	import com.pickgliss.ui.text.GradientText;
	import com.pickgliss.utils.ObjectUtils;
	import ddt.manager.DailyLeagueManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SoundManager;
	import ddt.utils.PositionUtils;
	import ddt.view.common.DailyLeagueLevel;
	import flash.display.Bitmap;
	import flash.events.Event;
	
	public class LeagueShowFrame extends Frame
	{
		
		
		private var _leftBack:MutipleImage;
		
		private var _leagueRank:DailyLeagueLevel;
		
		private var _leagueTitle:GradientText;
		
		private var _todayNumberTitle:Bitmap;
		
		private var _todayNumberBg:Bitmap;
		
		private var _todayNumberField:FilterFrameText;
		
		private var _todayScoreTitle:Bitmap;
		
		private var _todayScoreBg:Bitmap;
		
		private var _todayScoreField:FilterFrameText;
		
		private var _weekRankingTitle:Bitmap;
		
		private var _weekRankingBg:Bitmap;
		
		private var _weekRankingField:FilterFrameText;
		
		private var _weekScoreTitle:Bitmap;
		
		private var _weekScoreBg:Bitmap;
		
		private var _weekScoreField:FilterFrameText;
		
		private var _lv20_29Btn:SelectedButton;
		
		private var _lv30_39Btn:SelectedButton;
		
		private var _lv40_49Btn:SelectedButton;
		
		private var _levelSelGroup:SelectedButtonGroup;
		
		private var _scoreBtnI:SelectedTextButton;
		
		private var _scoreBtnII:SelectedTextButton;
		
		private var _scoreBtnIII:SelectedTextButton;
		
		private var _scoreBtnIV:SelectedTextButton;
		
		private var _scoreSelGroup:SelectedButtonGroup;
		
		private var _awardBox:SimpleTileList;
		
		private var _explanationPanel:ScrollPanel;
		
		private var _rightBack:MutipleImage;
		
		public function LeagueShowFrame()
		{
			super();
			this.initView();
			this.addEvent();
		}
		
		private function initView() : void
		{
			this._leftBack = ComponentFactory.Instance.creatComponentByStylename("leagueShow.leftBack");
			addToContent(this._leftBack);
			var _loc1_:Number = PlayerManager.Instance.Self.DailyLeagueLastScore;
			var _loc2_:Boolean = PlayerManager.Instance.Self.DailyLeagueFirst;
			this._leagueRank = new DailyLeagueLevel();
			this._leagueRank.leagueFirst = _loc2_;
			this._leagueRank.score = _loc1_;
			PositionUtils.setPos(this._leagueRank,"leagueShow.view.leagueRankPos");
			addToContent(this._leagueRank);
			this._leagueTitle = ComponentFactory.Instance.creat("leagueShow.view.leagueTitle");
			this._leagueTitle.text = DailyLeagueManager.Instance.getLeagueLevelByScore(_loc1_,_loc2_).Name;
			addToContent(this._leagueTitle);
			this._todayNumberTitle = ComponentFactory.Instance.creatBitmap("asset.leagueShow.todayNumberTxt");
			addToContent(this._todayNumberTitle);
			this._todayNumberBg = ComponentFactory.Instance.creatBitmap("asset.leagueShow.TextFieldBg");
			addToContent(this._todayNumberBg);
			this._todayNumberBg.y = this._todayNumberTitle.y;
			this._todayNumberField = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.todayNumberField");
			addToContent(this._todayNumberField);
			this._todayScoreTitle = ComponentFactory.Instance.creatBitmap("asset.leagueShow.todayScoreTxt");
			addToContent(this._todayScoreTitle);
			this._todayScoreBg = ComponentFactory.Instance.creatBitmap("asset.leagueShow.TextFieldBg");
			addToContent(this._todayScoreBg);
			this._todayScoreBg.y = this._todayScoreTitle.y;
			this._todayScoreField = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.todayScoreField");
			addToContent(this._todayScoreField);
			this._weekRankingTitle = ComponentFactory.Instance.creatBitmap("asset.leagueShow.weekRankingTxt");
			addToContent(this._weekRankingTitle);
			this._weekRankingBg = ComponentFactory.Instance.creatBitmap("asset.leagueShow.TextFieldBg");
			addToContent(this._weekRankingBg);
			this._weekRankingBg.y = this._weekRankingTitle.y;
			this._weekRankingField = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.weekRankingField");
			addToContent(this._weekRankingField);
			this._weekScoreTitle = ComponentFactory.Instance.creatBitmap("asset.leagueShow.weekScoreTxt");
			addToContent(this._weekScoreTitle);
			this._weekScoreBg = ComponentFactory.Instance.creatBitmap("asset.leagueShow.TextFieldBg");
			addToContent(this._weekScoreBg);
			this._weekScoreBg.y = this._weekScoreTitle.y;
			this._weekScoreField = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.weekScoreField");
			addToContent(this._weekScoreField);
			this._weekRankingField.text = String(PlayerManager.Instance.Self.matchInfo.weeklyRanking);
			this._weekScoreField.text = String(PlayerManager.Instance.Self.matchInfo.weeklyScore);
			this._todayNumberField.text = String(PlayerManager.Instance.Self.matchInfo.dailyGameCount);
			this._todayScoreField.text = String(PlayerManager.Instance.Self.matchInfo.dailyScore);
			this._rightBack = ComponentFactory.Instance.creatComponentByStylename("leagueShow.rightBack");
			addToContent(this._rightBack);
			this._explanationPanel = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.explanationPanel");
			this._explanationPanel.setView(ComponentFactory.Instance.creatBitmap("asset.leagueShow.explanationContentAsset"));
			addToContent(this._explanationPanel);
			this._lv20_29Btn = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.lv20_29selectBtn");
			addToContent(this._lv20_29Btn);
			this._lv20_29Btn.autoSelect = true;
			this._lv30_39Btn = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.lv30_39selectBtn");
			addToContent(this._lv30_39Btn);
			this._lv40_49Btn = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.lv40_49selectBtn");
			addToContent(this._lv40_49Btn);
			this._levelSelGroup = new SelectedButtonGroup();
			this._levelSelGroup.addSelectItem(this._lv20_29Btn);
			this._levelSelGroup.addSelectItem(this._lv30_39Btn);
			this._levelSelGroup.addSelectItem(this._lv40_49Btn);
			this._levelSelGroup.selectIndex = 0;
			this._scoreBtnI = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.awardScoreBtnI");
			this._scoreBtnII = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.awardScoreBtnII");
			this._scoreBtnIII = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.awardScoreBtnIII");
			this._scoreBtnIV = ComponentFactory.Instance.creatComponentByStylename("leagueShow.view.awardScoreBtnIV");
			addToContent(this._scoreBtnI);
			addToContent(this._scoreBtnII);
			addToContent(this._scoreBtnIII);
			addToContent(this._scoreBtnIV);
			this._scoreBtnI.text = LanguageMgr.GetTranslation("gotopage.view.LeagueShowFrame.scoreBtnText","10000");
			this._scoreBtnII.text = LanguageMgr.GetTranslation("gotopage.view.LeagueShowFrame.scoreBtnText","20000");
			this._scoreBtnIII.text = LanguageMgr.GetTranslation("gotopage.view.LeagueShowFrame.scoreBtnText","35000");
			this._scoreBtnIV.text = LanguageMgr.GetTranslation("gotopage.view.LeagueShowFrame.scoreBtnText","60000");
			this._scoreSelGroup = new SelectedButtonGroup();
			this._scoreSelGroup.addSelectItem(this._scoreBtnI);
			this._scoreSelGroup.addSelectItem(this._scoreBtnII);
			this._scoreSelGroup.addSelectItem(this._scoreBtnIII);
			this._scoreSelGroup.addSelectItem(this._scoreBtnIV);
			this._scoreSelGroup.selectIndex = 0;
			this._awardBox = ComponentFactory.Instance.creatCustomObject("leagueShow.view.awardBox",[7]);
			addToContent(this._awardBox);
			this.__onItemChanaged(null);
		}
		
		private function addEvent() : void
		{
			addEventListener(FrameEvent.RESPONSE,this.__onResponse);
			this._levelSelGroup.addEventListener(Event.CHANGE,this.__onItemChanaged);
			this._scoreSelGroup.addEventListener(Event.CHANGE,this.__onItemChanaged);
		}
		
		private function __onResponse(param1:FrameEvent) : void
		{
			SoundManager.instance.playButtonSound();
			this.dispose();
		}
		
		private function __onItemChanaged(param1:Event) : void
		{
			if(param1)
			{
				SoundManager.instance.playButtonSound();
			}
			this._awardBox.disposeAllChildren();
			ObjectUtils.removeChildAllChildren(this._awardBox);
			var _loc2_:Array = DailyLeagueManager.Instance.filterLeagueAwardList(this._levelSelGroup.selectIndex,this._scoreSelGroup.selectIndex);
			var _loc3_:int = Math.min(_loc2_.length,14);
			var _loc4_:int = 0;
			while(_loc4_ < _loc3_)
			{
				this._awardBox.addChild(new LeagueAwardCell(_loc2_[_loc4_]));
				_loc4_++;
			}
		}
		
		private function removeEvent() : void
		{
			removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
			this._levelSelGroup.removeEventListener(Event.CHANGE,this.__onItemChanaged);
			this._scoreSelGroup.removeEventListener(Event.CHANGE,this.__onItemChanaged);
		}
		
		override public function dispose() : void
		{
			this.removeEvent();
			super.dispose();
			if(this._leftBack)
			{
				ObjectUtils.disposeObject(this._leftBack);
			}
			this._leftBack = null;
			if(this._leagueRank)
			{
				ObjectUtils.disposeObject(this._leagueRank);
			}
			this._leagueRank = null;
			if(this._leagueTitle)
			{
				ObjectUtils.disposeObject(this._leagueTitle);
			}
			this._leagueTitle = null;
			if(this._todayNumberTitle)
			{
				ObjectUtils.disposeObject(this._todayNumberTitle);
			}
			this._todayNumberTitle = null;
			if(this._todayNumberBg)
			{
				ObjectUtils.disposeObject(this._todayNumberBg);
			}
			this._todayNumberBg = null;
			if(this._todayNumberField)
			{
				ObjectUtils.disposeObject(this._todayNumberField);
			}
			this._todayNumberField = null;
			if(this._todayScoreTitle)
			{
				ObjectUtils.disposeObject(this._todayScoreTitle);
			}
			this._todayScoreTitle = null;
			if(this._todayScoreBg)
			{
				ObjectUtils.disposeObject(this._todayScoreBg);
			}
			this._todayScoreBg = null;
			if(this._todayScoreField)
			{
				ObjectUtils.disposeObject(this._todayScoreField);
			}
			this._todayScoreField = null;
			if(this._weekRankingTitle)
			{
				ObjectUtils.disposeObject(this._weekRankingTitle);
			}
			this._weekRankingTitle = null;
			if(this._weekRankingBg)
			{
				ObjectUtils.disposeObject(this._weekRankingBg);
			}
			this._weekRankingBg = null;
			if(this._weekRankingField)
			{
				ObjectUtils.disposeObject(this._weekRankingField);
			}
			this._weekRankingField = null;
			if(this._weekScoreTitle)
			{
				ObjectUtils.disposeObject(this._weekScoreTitle);
			}
			this._weekScoreTitle = null;
			if(this._weekScoreBg)
			{
				ObjectUtils.disposeObject(this._weekScoreBg);
			}
			this._weekScoreBg = null;
			if(this._weekScoreField)
			{
				ObjectUtils.disposeObject(this._weekScoreField);
			}
			this._weekScoreField = null;
			if(this._lv20_29Btn)
			{
				ObjectUtils.disposeObject(this._lv20_29Btn);
			}
			this._lv20_29Btn = null;
			if(this._lv30_39Btn)
			{
				ObjectUtils.disposeObject(this._lv30_39Btn);
			}
			this._lv30_39Btn = null;
			if(this._lv40_49Btn)
			{
				ObjectUtils.disposeObject(this._lv40_49Btn);
			}
			this._lv40_49Btn = null;
			if(this._levelSelGroup)
			{
				ObjectUtils.disposeObject(this._levelSelGroup);
			}
			this._levelSelGroup = null;
			if(this._scoreBtnI)
			{
				ObjectUtils.disposeObject(this._scoreBtnI);
			}
			this._scoreBtnI = null;
			if(this._scoreBtnII)
			{
				ObjectUtils.disposeObject(this._scoreBtnII);
			}
			this._scoreBtnII = null;
			if(this._scoreBtnIII)
			{
				ObjectUtils.disposeObject(this._scoreBtnIII);
			}
			this._scoreBtnIII = null;
			if(this._scoreBtnIV)
			{
				ObjectUtils.disposeObject(this._scoreBtnIV);
			}
			this._scoreBtnIV = null;
			if(this._scoreSelGroup)
			{
				ObjectUtils.disposeObject(this._scoreSelGroup);
			}
			this._scoreSelGroup = null;
			if(this._awardBox)
			{
				ObjectUtils.disposeObject(this._awardBox);
			}
			this._awardBox = null;
			if(this._explanationPanel)
			{
				ObjectUtils.disposeObject(this._explanationPanel);
			}
			this._explanationPanel = null;
			if(this._rightBack)
			{
				ObjectUtils.disposeObject(this._rightBack);
			}
			this._rightBack = null;
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}

import bagAndInfo.cell.BaseCell;
import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.text.FilterFrameText;
import com.pickgliss.utils.ObjectUtils;
import ddt.data.DailyLeagueAwardInfo;
import ddt.manager.ItemManager;

class LeagueAwardCell extends BaseCell
{
	
	
	private var _awardInfo:DailyLeagueAwardInfo;
	
	private var _countTxt:FilterFrameText;
	
	function LeagueAwardCell(param1:DailyLeagueAwardInfo)
	{
		this._awardInfo = param1;
		super(ComponentFactory.Instance.creatBitmap("asset.leagueAward.cellBackAsset"),ItemManager.Instance.getTemplateById(this._awardInfo.TemplateID));
		this.initII();
	}
	
	protected function initII() : void
	{
		this._countTxt = ComponentFactory.Instance.creat("bossbox.boxCellCount");
		this._countTxt.text = String(this._awardInfo.Count);
		addChild(this._countTxt);
	}
	
	override public function dispose() : void
	{
		super.dispose();
		if(this._countTxt)
		{
			ObjectUtils.disposeObject(this._countTxt);
		}
		this._countTxt = null;
		ObjectUtils.disposeAllChildren(this);
		if(parent)
		{
			parent.removeChild(this);
		}
	}
}
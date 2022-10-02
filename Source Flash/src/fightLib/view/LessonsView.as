package fightLib.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.fightLib.FightLibInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.FightLibManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import fightLib.LessonType;
   import fightLib.script.FightLibGuideScripit;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LessonsView extends Sprite implements Disposeable
   {
       
      
      private var _background:Bitmap;
      
      private var _measureButton:LessonButton;
      
      private var _twentyButton:LessonButton;
      
      private var _sixtyFiveButton:LessonButton;
      
      private var _highThrowButton:LessonButton;
      
      private var _highGapButton:LessonButton;
      
      private var _lassButton:LessonButton;
      
      private var _levelGroup:SelectedButtonGroup;
      
      private var _lowButton:LevelButton;
      
      private var _mediumButton:LevelButton;
      
      private var _highButton:LevelButton;
      
      private var _startButton:MovieClip;
      
      private var _cancelButton:MovieClip;
      
      private var _lessonType:int;
      
      private var _selectedLesson:LessonButton;
      
      private var _selectedLevel:LevelButton;
      
      private var _lessonButtons:Vector.<LessonButton>;
      
      private var _levelButtons:Vector.<LevelButton>;
      
      private var _sencondType:int = 3;
      
      private var _guildMovie:MovieClip;
      
      private var _awardView:FightLibAwardView;
      
      public function LessonsView()
      {
         this._lessonButtons = new Vector.<LessonButton>();
         this._levelButtons = new Vector.<LevelButton>();
         super();
         this.configUI();
         this.addEvent();
         this.updateLessonButtonState();
         this.updateLevelButtonState();
      }
      
      private function configUI() : void
      {
         this._background = ComponentFactory.Instance.creatBitmap("fightLib.lesson.background");
         addChild(this._background);
         this._measureButton = ComponentFactory.Instance.creatCustomObject("fightLib.Lesson.MeasureButton");
         this._measureButton.type = LessonType.Measure;
         this._lessonButtons.push(this._measureButton);
         addChild(this._measureButton);
         this._twentyButton = ComponentFactory.Instance.creatCustomObject("fightLib.Lesson.TwentyButton");
         this._twentyButton.type = LessonType.Twenty;
         this._lessonButtons.push(this._twentyButton);
         addChild(this._twentyButton);
         this._sixtyFiveButton = ComponentFactory.Instance.creatCustomObject("fightLib.Lesson.SixtyFiveButton");
         this._sixtyFiveButton.type = LessonType.SixtyFive;
         this._lessonButtons.push(this._sixtyFiveButton);
         addChild(this._sixtyFiveButton);
         this._highThrowButton = ComponentFactory.Instance.creatCustomObject("fightLib.Lesson.HighThrowButton");
         this._highThrowButton.type = LessonType.HighThrow;
         this._lessonButtons.push(this._highThrowButton);
         addChild(this._highThrowButton);
         this._highGapButton = ComponentFactory.Instance.creatCustomObject("fightLib.Lesson.HighGapButton");
         this._highGapButton.type = LessonType.HighGap;
         this._lessonButtons.push(this._highGapButton);
         addChild(this._highGapButton);
         this._lassButton = ComponentFactory.Instance.creatCustomObject("fightLib.Lesson.LassButton");
         addChild(this._lassButton);
         this._lowButton = ComponentFactory.Instance.creatCustomObject("fightLib.lesson.LowButton");
         addChild(this._lowButton);
         this._mediumButton = ComponentFactory.Instance.creatCustomObject("fightLib.lesson.MediumButton");
         addChild(this._mediumButton);
         this._highButton = ComponentFactory.Instance.creatCustomObject("fightLib.lesson.HighButton");
         addChild(this._highButton);
         this._levelButtons.push(this._lowButton);
         this._levelButtons.push(this._mediumButton);
         this._levelButtons.push(this._highButton);
         this._startButton = ComponentFactory.Instance.creatCustomObject("fightLib.Lessons.StartButton");
         addChild(this._startButton);
         this._cancelButton = ComponentFactory.Instance.creatCustomObject("fightLib.Lessons.CancelButton");
         addChild(this._cancelButton);
         this._awardView = ComponentFactory.Instance.creatCustomObject("fightLib.view.FightLibAwardView");
         addChild(this._awardView);
         this._guildMovie = ComponentFactory.Instance.creatCustomObject("fightLib.Lessons.GuildMovie");
         addChild(this._guildMovie);
         this.updateLessonButtonState();
         this.updateLevelButtonState();
      }
      
      private function updateLast() : void
      {
         this.unSelectedAllLesson();
         this.unselectedAllLevel();
         if(FightLibManager.Instance.lastInfo != null)
         {
            switch(FightLibManager.Instance.lastInfo.id)
            {
               case LessonType.Measure:
                  this.selectedLesson = this._measureButton;
                  break;
               case LessonType.Twenty:
                  this.selectedLesson = this._twentyButton;
                  break;
               case LessonType.SixtyFive:
                  this.selectedLesson = this._sixtyFiveButton;
                  break;
               case LessonType.HighThrow:
                  this.selectedLesson = this._highThrowButton;
                  break;
               case LessonType.HighGap:
                  this.selectedLesson = this._highGapButton;
                  break;
               default:
                  return;
            }
            switch(FightLibManager.Instance.lastInfo.difficulty)
            {
               case FightLibInfo.EASY:
                  this.selectedLevel = this._lowButton;
                  break;
               case FightLibInfo.NORMAL:
                  this.selectedLevel = this._mediumButton;
                  break;
               case FightLibInfo.DIFFICULT:
                  this.selectedLevel = this._highButton;
                  break;
               default:
                  return;
            }
            this.updateModel();
            this.updateModelII();
            this.updateLevelButtonState();
            this.updateAward();
            return;
         }
      }
      
      private function updateSencondType() : void
      {
         if(FightLibManager.Instance.currentInfo && (FightLibManager.Instance.currentInfo.id == LessonType.Twenty || FightLibManager.Instance.currentInfo.id == LessonType.SixtyFive || FightLibManager.Instance.currentInfo.id == LessonType.HighThrow))
         {
            if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
            {
               this._sencondType = 6;
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
            {
               this._sencondType = 5;
            }
            else
            {
               this._sencondType = 3;
            }
         }
         else if(FightLibManager.Instance.currentInfo && FightLibManager.Instance.currentInfo.id == LessonType.HighGap)
         {
            if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
            {
               this._sencondType = 5;
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
            {
               this._sencondType = 4;
            }
            else
            {
               this._sencondType = 3;
            }
         }
      }
      
      private function updateLessonButtonState() : void
      {
         if(FightLibManager.Instance.getFightLibInfoByID(LessonType.Measure))
         {
            this._measureButton.enabled = FightLibManager.Instance.getFightLibInfoByID(LessonType.Measure).InfoCanPlay;
         }
         else
         {
            this._measureButton.enabled = false;
         }
         if(FightLibManager.Instance.getFightLibInfoByID(LessonType.Twenty))
         {
            this._twentyButton.enabled = FightLibManager.Instance.getFightLibInfoByID(LessonType.Twenty).InfoCanPlay;
         }
         else
         {
            this._twentyButton.enabled = false;
         }
         if(FightLibManager.Instance.getFightLibInfoByID(LessonType.SixtyFive))
         {
            this._sixtyFiveButton.enabled = FightLibManager.Instance.getFightLibInfoByID(LessonType.SixtyFive).InfoCanPlay;
         }
         else
         {
            this._sixtyFiveButton.enabled = false;
         }
         if(FightLibManager.Instance.getFightLibInfoByID(LessonType.HighThrow))
         {
            this._highThrowButton.enabled = FightLibManager.Instance.getFightLibInfoByID(LessonType.HighThrow).InfoCanPlay;
         }
         else
         {
            this._highThrowButton.enabled = false;
         }
         if(FightLibManager.Instance.getFightLibInfoByID(LessonType.HighGap))
         {
            this._highGapButton.enabled = FightLibManager.Instance.getFightLibInfoByID(LessonType.HighGap).InfoCanPlay;
         }
         else
         {
            this._highGapButton.enabled = false;
         }
      }
      
      private function updateLevelButtonState() : void
      {
         if(FightLibManager.Instance.currentInfo != null)
         {
            this._lowButton.enable = FightLibManager.Instance.currentInfo.easyCanPlay;
            this._mediumButton.enable = FightLibManager.Instance.currentInfo.normalCanPlay;
            this._highButton.enable = FightLibManager.Instance.currentInfo.difficultCanPlay;
         }
         else
         {
            this._lowButton.enable = this._mediumButton.enable = this._highButton.enable = false;
         }
      }
      
      private function updateAward() : void
      {
         if(FightLibManager.Instance.currentInfo != null && FightLibManager.Instance.currentInfo.difficulty > -1)
         {
            this._awardView.visible = true;
            this._awardView.setGiftAndExpNum(FightLibManager.Instance.currentInfo.getAwardGiftsNum(),FightLibManager.Instance.currentInfo.getAwardEXPNum(),FightLibManager.Instance.currentInfo.getAwardMedal());
            this._awardView.setAwardItems(FightLibManager.Instance.currentInfo.getAwardItems());
            this._awardView.geted = false;
            this.updateAwardGainedState();
         }
         else
         {
            this._awardView.visible = false;
         }
      }
      
      private function updateAwardGainedState() : void
      {
         if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
         {
            if(FightLibManager.Instance.currentInfo.easyAwardGained)
            {
               this._awardView.geted = true;
            }
         }
         else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
         {
            if(FightLibManager.Instance.currentInfo.normalAwardGained)
            {
               this._awardView.geted = true;
            }
         }
         else if(FightLibManager.Instance.currentInfo.difficultAwardGained)
         {
            this._awardView.geted = true;
         }
      }
      
      private function addEvent() : void
      {
         this._measureButton.addEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._twentyButton.addEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._sixtyFiveButton.addEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._highThrowButton.addEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._highGapButton.addEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._startButton.addEventListener(MouseEvent.CLICK,this.__start);
         this._cancelButton.addEventListener(MouseEvent.CLICK,this.__cancel);
         this._lowButton.addEventListener(MouseEvent.CLICK,this.__levelClick);
         this._mediumButton.addEventListener(MouseEvent.CLICK,this.__levelClick);
         this._highButton.addEventListener(MouseEvent.CLICK,this.__levelClick);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__update);
         FightLibManager.Instance.addEventListener(FightLibManager.GAINAWARD,this.__gainAward);
      }
      
      private function __gainAward(param1:Event) : void
      {
      }
      
      private function __update(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["fightLibMission"])
         {
            this.updateLessonButtonState();
            this.updateLevelButtonState();
            this.updateAward();
         }
      }
      
      private function removeEvent() : void
      {
         this._measureButton.removeEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._twentyButton.removeEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._sixtyFiveButton.removeEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._highThrowButton.removeEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._highGapButton.removeEventListener(LessonButton.SelectedLesson,this.__selectLesson);
         this._startButton.removeEventListener(MouseEvent.CLICK,this.__start);
         this._cancelButton.removeEventListener(MouseEvent.CLICK,this.__cancel);
         this._lowButton.removeEventListener(MouseEvent.CLICK,this.__levelClick);
         this._mediumButton.removeEventListener(MouseEvent.CLICK,this.__levelClick);
         this._highButton.removeEventListener(MouseEvent.CLICK,this.__levelClick);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__update);
         FightLibManager.Instance.removeEventListener(FightLibManager.GAINAWARD,this.__gainAward);
      }
      
      private function __levelClick(param1:MouseEvent) : void
      {
         var _loc2_:LevelButton = null;
         var _loc3_:LessonButton = null;
         SoundManager.instance.play("008");
         if(FightLibManager.Instance.currentInfo == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.fightLib.ChooseFightLibTypeView.selectFightLibInfo"));
            for each(_loc3_ in this._lessonButtons)
            {
               _loc3_.shine = _loc3_.enabled == true;
            }
            return;
         }
         for each(_loc2_ in this._levelButtons)
         {
            if(_loc2_.enable)
            {
               _loc2_.shine = false;
            }
         }
         this.unselectedAllLevel();
         this.selectedLevel = param1.currentTarget as LevelButton;
         this.updateModelII();
         this.updateAward();
         this.updateSencondType();
         GameInSocketOut.sendGameRoomSetUp(FightLibManager.Instance.currentInfo.id,5,false,"","",this._sencondType,FightLibManager.Instance.currentInfo.difficulty,0,false,0);
         if(param1.currentTarget == this._lowButton && FightLibManager.Instance.script && FightLibManager.Instance.script is FightLibGuideScripit)
         {
            FightLibManager.Instance.script.continueScript();
            FightLibManager.Instance.script.dispose();
            FightLibManager.Instance.script = null;
         }
      }
      
      private function updateModelII() : void
      {
         if(this._lowButton.selected)
         {
            FightLibManager.Instance.currentInfo.difficulty = FightLibInfo.EASY;
         }
         else if(this._mediumButton.selected)
         {
            FightLibManager.Instance.currentInfo.difficulty = FightLibInfo.NORMAL;
         }
         else if(this._highButton.selected)
         {
            FightLibManager.Instance.currentInfo.difficulty = FightLibInfo.DIFFICULT;
         }
      }
      
      private function __selectLesson(param1:Event) : void
      {
         var _loc4_:LessonButton = null;
         var _loc5_:LevelButton = null;
         var _loc2_:LessonButton = param1.currentTarget as LessonButton;
         var _loc3_:int = _loc2_.type;
         SoundManager.instance.play("008");
         if(this._selectedLesson && this._selectedLesson.type == _loc3_)
         {
            return;
         }
         for each(_loc4_ in this._lessonButtons)
         {
            if(_loc4_.enabled)
            {
               _loc4_.shine = false;
            }
         }
         for each(_loc5_ in this._levelButtons)
         {
            if(_loc5_.enable)
            {
               _loc5_.shine = false;
            }
         }
         this.unSelectedAllLesson();
         this.unselectedAllLevel();
         this.selectedLesson = _loc2_;
         this.updateModel();
         this.updateLevelButtonState();
         if(_loc3_ == LessonType.Measure && FightLibManager.Instance.script && FightLibManager.Instance.script is FightLibGuideScripit)
         {
            FightLibManager.Instance.script.continueScript();
         }
      }
      
      private function unSelectedAllLesson() : void
      {
         var _loc1_:LessonButton = null;
         for each(_loc1_ in this._lessonButtons)
         {
            _loc1_.selected = false;
         }
      }
      
      private function unselectedAllLevel() : void
      {
         this._lowButton.selected = this._mediumButton.selected = this._highButton.selected = false;
      }
      
      private function updateModel() : void
      {
         FightLibManager.Instance.currentInfoID = this.selectedLesson.type;
         FightLibManager.Instance.currentInfo.difficulty = -1;
         this.updateAward();
      }
      
      private function __start(param1:MouseEvent) : void
      {
         var _loc2_:LessonButton = null;
         var _loc3_:LevelButton = null;
         SoundManager.instance.play("008");
         if(FightLibManager.Instance.currentInfo == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.fightLib.ChooseFightLibTypeView.selectFightLibInfo"));
            for each(_loc2_ in this._lessonButtons)
            {
               _loc2_.shine = _loc2_.enabled == true;
            }
            return;
         }
         if(FightLibManager.Instance.currentInfo.difficulty < 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.fightLib.ChooseFightLibTypeView.selectDifficulty"));
            for each(_loc3_ in this._levelButtons)
            {
               _loc3_.shine = _loc3_.enable == true;
            }
            return;
         }
         if(PlayerManager.Instance.Self.WeaponID <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            return;
         }
         this._startButton.visible = false;
         this._cancelButton.visible = true;
         GameInSocketOut.sendGameStart();
      }
      
      private function __cancel(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendCancelWait();
         this._cancelButton.visible = false;
         this._startButton.visible = true;
      }
      
      public function hideShine() : void
      {
         var _loc1_:LessonButton = null;
         var _loc2_:LevelButton = null;
         for each(_loc1_ in this._lessonButtons)
         {
            if(_loc1_.enabled)
            {
               _loc1_.shine = false;
            }
         }
         for each(_loc2_ in this._levelButtons)
         {
            if(_loc2_.enable)
            {
               _loc2_.shine = false;
            }
         }
      }
      
      public function showShine(param1:int) : void
      {
         var _loc2_:LessonButton = null;
         var _loc3_:LevelButton = null;
         if(param1 == 1)
         {
            for each(_loc2_ in this._lessonButtons)
            {
               if(_loc2_.enabled)
               {
                  _loc2_.shine = true;
               }
            }
         }
         else if(param1 == 2)
         {
            for each(_loc3_ in this._levelButtons)
            {
               if(_loc3_.enable)
               {
                  _loc3_.shine = true;
               }
            }
         }
      }
      
      public function getGuild() : MovieClip
      {
         return this._guildMovie;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._background)
         {
            ObjectUtils.disposeObject(this._background);
            this._background = null;
         }
         if(this._awardView)
         {
            ObjectUtils.disposeObject(this._awardView);
            this._awardView = null;
         }
         if(this._cancelButton)
         {
            ObjectUtils.disposeObject(this._cancelButton);
            this._cancelButton = null;
         }
         if(this._guildMovie)
         {
            ObjectUtils.disposeObject(this._guildMovie);
            this._guildMovie = null;
         }
         if(this._highButton)
         {
            ObjectUtils.disposeObject(this._highButton);
            this._highButton = null;
         }
         if(this._highGapButton)
         {
            ObjectUtils.disposeObject(this._highGapButton);
            this._highGapButton = null;
         }
         if(this._highThrowButton)
         {
            ObjectUtils.disposeObject(this._highThrowButton);
            this._highThrowButton = null;
         }
         if(this._lassButton)
         {
            ObjectUtils.disposeObject(this._lassButton);
            this._lassButton = null;
         }
         if(this._lowButton)
         {
            ObjectUtils.disposeObject(this._lowButton);
            this._lowButton = null;
         }
         if(this._measureButton)
         {
            ObjectUtils.disposeObject(this._measureButton);
            this._measureButton = null;
         }
         if(this._mediumButton)
         {
            ObjectUtils.disposeObject(this._mediumButton);
            this._mediumButton = null;
         }
         if(this._sixtyFiveButton)
         {
            ObjectUtils.disposeObject(this._sixtyFiveButton);
            this._sixtyFiveButton = null;
         }
         if(this._startButton)
         {
            ObjectUtils.disposeObject(this._startButton);
            this._startButton = null;
         }
         if(this._twentyButton)
         {
            ObjectUtils.disposeObject(this._twentyButton);
            this._twentyButton = null;
         }
         this._selectedLesson = null;
         this._selectedLevel = null;
      }
      
      public function set selectedLesson(param1:LessonButton) : void
      {
         var _loc2_:LessonButton = this._selectedLesson;
         this._selectedLesson = param1;
         this._selectedLesson.selected = true;
         if(_loc2_ && _loc2_ != this._selectedLesson)
         {
            _loc2_.selected = false;
         }
      }
      
      public function get selectedLesson() : LessonButton
      {
         return this._selectedLesson;
      }
      
      public function set selectedLevel(param1:LevelButton) : void
      {
         var _loc2_:LevelButton = this._selectedLevel;
         this._selectedLevel = param1;
         this._selectedLevel.selected = true;
         if(_loc2_ && _loc2_ != this._selectedLevel)
         {
            _loc2_.selected = false;
         }
      }
      
      public function get selectedLevel() : LevelButton
      {
         return this._selectedLevel;
      }
   }
}

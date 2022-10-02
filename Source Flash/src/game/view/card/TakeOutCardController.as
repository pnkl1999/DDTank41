package game.view.card
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.map.MissionInfo;
   import ddt.events.RoomEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import game.model.GameInfo;
   import game.model.Player;
   import game.view.experience.ExpTweenManager;
   import labyrinth.LabyrinthManager;
   import org.aswing.KeyboardManager;
   import road7th.data.DictionaryEvent;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   
   public class TakeOutCardController extends EventDispatcher implements Disposeable
   {
       
      
      private var _gameInfo:GameInfo;
      
      private var _roomInfo:RoomInfo;
      
      private var _cardView:SmallCardsView;
      
      private var _showSmallCardView:Function;
      
      private var _showLargeCardView:Function;
      
      private var _isKicked:Boolean;
      
      private var _disposeFunc:Function;
      
      public function TakeOutCardController(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function setup(param1:GameInfo, param2:RoomInfo) : void
      {
         this._gameInfo = param1;
         this._roomInfo = param2;
         this.initEvent();
         if(this._gameInfo.selfGamePlayer.hasGardGet)
         {
            this.drawCardGetBuff();
         }
      }
      
      private function drawCardGetBuff() : void
      {
      }
      
      public function set disposeFunc(param1:Function) : void
      {
         this._disposeFunc = param1;
      }
      
      public function set showSmallCardView(param1:Function) : void
      {
         this._showSmallCardView = param1;
      }
      
      public function set showLargeCardView(param1:Function) : void
      {
         this._showLargeCardView = param1;
      }
      
      private function initEvent() : void
      {
         this._gameInfo.addEventListener(GameInfo.REMOVE_ROOM_PLAYER,this.__removePlayer);
         this._roomInfo.addEventListener(RoomEvent.REMOVE_PLAYER,this.__removeRoomPlayer);
      }
      
      private function __removePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:Player = param1.data as Player;
         if(_loc2_ && _loc2_.isSelf)
         {
            if(this._roomInfo.type == RoomInfo.MATCH_ROOM || this._roomInfo.type == RoomInfo.CHALLENGE_ROOM)
            {
               StateManager.setState(StateType.ROOM_LIST);
            }
            else
            {
               StateManager.setState(StateType.DUNGEON_LIST);
            }
         }
      }
      
      private function __removeRoomPlayer(param1:RoomEvent) : void
      {
         var _loc2_:RoomPlayer = param1.params[0] as RoomPlayer;
         if(_loc2_ && _loc2_.isSelf)
         {
            this._isKicked = true;
         }
      }
      
      public function tryShowCard() : void
      {
         if(this._gameInfo.roomType == RoomInfo.MATCH_ROOM || this._gameInfo.roomType == RoomInfo.CHALLENGE_ROOM)
         {
            this._cardView = new SmallCardsView();
            PositionUtils.setPos(this._cardView,"takeoutCard.SmallCardViewPos");
            this._cardView.addEventListener(Event.COMPLETE,this.__onCardViewComplete);
            this._showSmallCardView(this._cardView);
            return;
         }
         if(this._gameInfo.selfGamePlayer.isWin)
         {
            if(PlayerManager.Instance.Self.Grade < 2)
            {
               this._gameInfo.missionInfo.tackCardType = MissionInfo.HAVE_NO_CARD;
            }
            if(this._gameInfo.missionInfo.tackCardType == MissionInfo.SMALL_TAKE_CARD)
            {
               this._cardView = new SmallCardsView();
               PositionUtils.setPos(this._cardView,"takeoutCard.SmallCardViewPos");
               this._cardView.addEventListener(Event.COMPLETE,this.__onCardViewComplete);
               this._showSmallCardView(this._cardView);
            }
            else if(this._gameInfo.missionInfo.tackCardType == MissionInfo.BIG_TACK_CARD)
            {
               this._cardView = new LargeCardsView();
               this._cardView.addEventListener(Event.COMPLETE,this.__onCardViewComplete);
               PositionUtils.setPos(this._cardView,"takeoutCard.LargeCardViewPos");
               this._showLargeCardView(this._cardView);
            }
            else
            {
               this.__onCardViewComplete();
            }
         }
         else
         {
            this.setState();
         }
      }
      
      private function __onCardViewComplete(param1:Event = null) : void
      {
         if(this._cardView)
         {
            this._cardView.removeEventListener(Event.COMPLETE,this.__onCardViewComplete);
         }
         this.setState();
      }
      
      private function removeEvent() : void
      {
         if(this._cardView)
         {
            this._cardView.removeEventListener(Event.COMPLETE,this.__onCardViewComplete);
            this._cardView.dispose();
         }
         this._gameInfo.removeEventListener(GameInfo.REMOVE_ROOM_PLAYER,this.__removePlayer);
         this._roomInfo.removeEventListener(RoomEvent.REMOVE_PLAYER,this.__removeRoomPlayer);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         KeyboardManager.getInstance().isStopDispatching = false;
         SocketManager.Instance.out.sendGetTropToBag(-1);
         PlayerManager.Instance.Self.TempBag.clearnAll();
         ExpTweenManager.Instance.isPlaying = false;
         this._cardView = null;
         this._gameInfo = null;
         this._roomInfo = null;
         this._disposeFunc = null;
         this._showSmallCardView = null;
         this._showLargeCardView = null;
      }
      
      public function setState() : void
      {
         this._disposeFunc();
         var _loc1_:String = "";
         var _loc2_:Function = null;
         if(this._isKicked)
         {
            if(this._roomInfo.type == RoomInfo.MATCH_ROOM || this._roomInfo.type == RoomInfo.CHALLENGE_ROOM)
            {
               _loc1_ = StateType.ROOM_LIST;
            }
            else
            {
               _loc1_ = StateType.DUNGEON_LIST;
            }
         }
         else if(this._roomInfo.type == RoomInfo.MATCH_ROOM || this._roomInfo.type == RoomInfo.SCORE_ROOM)
         {
            _loc1_ = StateType.MATCH_ROOM;
         }
         else if(this._roomInfo.type == RoomInfo.RANK_ROOM)
         {
            _loc1_ = StateType.ROOM_LIST;
         }
         else if(this._roomInfo.type == RoomInfo.CHALLENGE_ROOM)
         {
            _loc1_ = StateType.CHALLENGE_ROOM;
         }
         else if(this._roomInfo.type == RoomInfo.FRESHMAN_ROOM)
         {
            _loc1_ = StateType.MAIN;
         }
         else if((this._roomInfo.type == RoomInfo.DUNGEON_ROOM || this._roomInfo.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON || this._roomInfo.type == RoomInfo.ACADEMY_DUNGEON_ROOM) && this._gameInfo.hasNextMission)
         {
            _loc1_ = StateType.MISSION_ROOM;
         }
         else if(this._roomInfo.type == RoomInfo.FIGHT_LIB_ROOM)
         {
            _loc1_ = StateType.FIGHT_LIB;
         }
         else if(this._roomInfo.type == RoomInfo.NULL_ROOM)
         {
            _loc1_ = StateType.DUNGEON_LIST;
         }
         else if(this._roomInfo.type == RoomInfo.DUNGEON_ROOM || this._roomInfo.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON)
         {
            _loc1_ = StateType.DUNGEON_ROOM;
         }
         else if(this._roomInfo.type == RoomInfo.LANBYRINTH_ROOM)
         {
            _loc2_ = LabyrinthManager.Instance.show;
            _loc1_ = StateType.MAIN;
         }
		 else if(this._roomInfo.type == RoomInfo.WORLD_BOSS_FIGHT)
		 {
			 _loc1_ = StateType.WORLDBOSS_ROOM;
		 }
         else
         {
            _loc1_ = StateType.DUNGEON_ROOM;
         }
         StateManager.setState(_loc1_,_loc2_);
         this.dispose();
      }
   }
}

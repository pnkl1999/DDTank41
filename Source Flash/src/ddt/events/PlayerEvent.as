package ddt.events
{
   import flash.events.Event;
   
   public class PlayerEvent extends Event
   {
      
      public static const BLOOD_CHANGED:String = "bloodChanged";
      
      public static const TEAM_CHANGED:String = "teamChanged";
      
      public static const HOST_CHANGED:String = "hostChanged";
      
      public static const READY_CHANGED:String = "readyChanged";
      
      public static const ROOMPOS_CHANGED:String = "roomposChanged";
      
      public static const POS_CHANGED:String = "posChanged";
      
      public static const POS_DEAD_PLAYER:String = "posDeadPlayer";
      
      public static const INVIOLABLE_CHANGED:String = "inviolableChanged";
      
      public static const SHOOT:String = "shoot";
      
      public static const BEGIN_SHOOT:String = "beginShoot";
      
      public static const DANDER_CHANGED:String = "danderChanged";
      
      public static const FORZEN_CHANGED:String = "forzenChanged";
      
      public static const ATTACKING_CHANGED:String = "attackingChanged";
      
      public static const USING_PROP:String = "usingProp";
      
      public static const DIR_CHANGED:String = "dirChanged";
      
      public static const ADD_STATE:String = "addState";
      
      public static const HIDDEN_CHANGED:String = "hiddenChanged";
      
      public static const NONOLE_CHANGED:String = "noNoleChanged";
      
      public static const TRANSMIT:String = "transmit";
      
      public static const START_MOVING:String = "startMoving";
      
      public static const STOP_MOVING:String = "stopMoving";
      
      public static const ENERGY_CHANGED:String = "energyChanged";
      
      public static const GUNANGLE_CHANGED:String = "gunangleChanged";
      
      public static const PLAYERANGLE_CHANGED:String = "playerangleChanged";
      
      public static const FORCE_CHANGED:String = "forceChanged";
      
      public static const BOMB_CHANGED:String = "bombChanged";
      
      public static const DIE:String = "die";
      
      public static const TARGETPOS_CHANGED:String = "targetposChanged";
      
      public static const BEGIN_NEW_TURN:String = "beginNewTurn";
      
      public static const USING_SPECIAL_SKILL:String = "usingSpecialSkill";
      
      public static const TROPHY_EVENT:String = "trophyEvent";
      
      public static const LEADER_CHANGE:String = "leaderchange";
      
      public static const PLAYER_OUT_SHOOT:String = "playerOutShoot";
      
      public static const PLAYER_SHOOT_TAG:String = "playerShootTag";
      
      public static const LOADING_PROGRESS:String = "loadingprogress";
      
      public static const UPDATE_GRADE:String = "updateGrade";
      
      public static const NOENTERGY_CARTOON:String = "noEnergyCartoon";
      
      public static const UPDATE_BLOOD_BYFLYOUTMAO:String = "updateBloodByFlyoutmap";
      
      public static const SKIP:String = "skip";
      
      public static const BEAT:String = "beat";
      
      public static const ONLINE:String = "online";
       
      
      private var _value:Number;
      
      private var _old:Number;
      
      private var _paras:Array;
      
      public function PlayerEvent(param1:String, param2:Number = 0, param3:Number = 0, ... rest)
      {
         super(param1);
         this._value = param2;
         this._old = param3;
         this._paras = rest;
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function get old() : Number
      {
         return this._old;
      }
      
      public function get paras() : Array
      {
         return this._paras;
      }
   }
}

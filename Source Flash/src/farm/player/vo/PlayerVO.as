package farm.player.vo
{
   import ddt.data.player.PlayerInfo;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   
   public class PlayerVO extends EventDispatcher
   {
       
      
      private var _playerInfo:PlayerInfo;
      
      private var _playerPos:Point;
      
      private var _playerMoveSpeed:Number = 0.15;
      
      private var _sceneCharacterDirection:SceneCharacterDirection;
      
      private var _playerDirection:int = 3;
      
      private var _walkPath:Array;
      
      public var currentWalkStartPoint:Point;
      
      public function PlayerVO(param1:IEventDispatcher = null)
      {
         this._walkPath = [];
         super(param1);
         this._sceneCharacterDirection = SceneCharacterDirection.RB;
      }
      
      public function get scenePlayerDirection() : SceneCharacterDirection
      {
         if(!this._sceneCharacterDirection)
         {
            this._sceneCharacterDirection = SceneCharacterDirection.RB;
         }
         return this._sceneCharacterDirection;
      }
      
      public function set scenePlayerDirection(param1:SceneCharacterDirection) : void
      {
         this._sceneCharacterDirection = param1;
         switch(this._sceneCharacterDirection)
         {
            case SceneCharacterDirection.RT:
               this._playerDirection = 1;
               break;
            case SceneCharacterDirection.LT:
               this._playerDirection = 2;
               break;
            case SceneCharacterDirection.RB:
               this._playerDirection = 3;
               break;
            case SceneCharacterDirection.LB:
               this._playerDirection = 4;
         }
      }
      
      public function get playerPos() : Point
      {
         return this._playerPos;
      }
      
      public function set playerPos(param1:Point) : void
      {
         this._playerPos = param1;
      }
      
      public function get playerMoveSpeed() : Number
      {
         return this._playerMoveSpeed;
      }
      
      public function set playerMoveSpeed(param1:Number) : void
      {
         this._playerMoveSpeed = param1;
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerInfo;
      }
      
      public function set playerInfo(param1:PlayerInfo) : void
      {
         this._playerInfo = param1;
      }
      
      public function get walkPath() : Array
      {
         return this._walkPath;
      }
      
      public function set walkPath(param1:Array) : void
      {
         this._walkPath = param1;
      }
   }
}

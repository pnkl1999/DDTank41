package ddt.view.sceneCharacter
{
   import ddt.events.SceneCharacterEvent;
   import ddt.view.scenePathSearcher.SceneMTween;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class SceneCharacterPlayerBase extends Sprite
   {
       
      
      private var _callBack:Function;
      
      private var _sceneCharacterDirection:SceneCharacterDirection;
      
      private var _sceneCharacterStateSet:SceneCharacterStateSet;
      
      private var _sceneCharacterStateType:String;
      
      private var _sceneCharacterStateItem:SceneCharacterStateItem;
      
      private var _characterVisible:Boolean = true;
      
      protected var _moveSpeed:Number = 0.15;
      
      protected var _walkPath:Array;
      
      protected var _tween:SceneMTween;
      
      private var _walkDistance:Number;
      
      public var character:Sprite;
      
      private var _walkPath0:Point;
      
      private var po1:Point;
      
      private var _loadComplete:Boolean = false;
      
      public var isDefaultCharacter:Boolean;
      
      public function SceneCharacterPlayerBase(param1:Function = null)
      {
         this._sceneCharacterDirection = SceneCharacterDirection.RB;
         super();
         this._callBack = param1;
         this.initialize();
      }
      
      public function get loadComplete() : Boolean
      {
         return this._loadComplete;
      }
      
      public function set loadComplete(param1:Boolean) : void
      {
         this._loadComplete = param1;
      }
      
      private function initialize() : void
      {
         this._tween = new SceneMTween(this);
         this.character = new Sprite();
         addChildAt(this.character,0);
         this.setEvent();
      }
      
      private function setEvent() : void
      {
         this._tween.addEventListener(SceneMTween.FINISH,this.__finish);
         this._tween.addEventListener(SceneMTween.CHANGE,this.__change);
      }
      
      private function removeEvent() : void
      {
         if(this._tween)
         {
            this._tween.removeEventListener(SceneMTween.FINISH,this.__finish);
         }
         if(this._tween)
         {
            this._tween.removeEventListener(SceneMTween.CHANGE,this.__change);
         }
      }
      
      private function __change(param1:Event) : void
      {
         dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_MOVEMENT,null));
      }
      
      private function __finish(param1:Event) : void
      {
         this.playerWalk(this._walkPath);
         dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP));
      }
      
      public function playerWalk(param1:Array) : void
      {
         this._walkPath = param1;
         if(this._walkPath && this._walkPath.length > 0)
         {
            this.sceneCharacterDirection = SceneCharacterDirection.getDirection(new Point(this.x,this.y),this._walkPath[0]);
            dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,true));
            this._walkPath0 = this._walkPath[0] as Point;
            this.po1 = new Point(this.x,this.y);
            this._walkDistance = Point.distance(this._walkPath0,new Point(this.x,this.y));
            this._tween.start(this._walkDistance / this._moveSpeed,"x",this._walkPath[0].x,"y",this._walkPath[0].y);
            this._walkPath.shift();
         }
         else
         {
            dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,false));
         }
      }
      
      public function set sceneCharacterActionType(param1:String) : void
      {
         if(this._sceneCharacterStateItem.setSceneCharacterActionType == param1)
         {
            return;
         }
         this._sceneCharacterStateItem.setSceneCharacterActionType = param1;
         dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,param1));
      }
      
      public function get playerPoint() : Point
      {
         return new Point(this.x,this.y);
      }
      
      public function set playerPoint(param1:Point) : void
      {
         this.x = param1.x;
         this.y = param1.y;
      }
      
      public function get moveSpeed() : Number
      {
         return this._moveSpeed;
      }
      
      public function set moveSpeed(param1:Number) : void
      {
         if(this._moveSpeed == param1)
         {
            return;
         }
         this._moveSpeed = param1;
      }
      
      public function get walkPath() : Array
      {
         return this._walkPath;
      }
      
      public function set walkPath(param1:Array) : void
      {
         this._walkPath = param1;
      }
      
      protected function set sceneCharacterStateSet(param1:SceneCharacterStateSet) : void
      {
         this._sceneCharacterStateSet = param1;
         this.sceneCharacterStateType = this._sceneCharacterStateSet.dataSet[0].type;
         if(this._callBack != null)
         {
            this._callBack(this,true);
         }
      }
      
      public function update() : void
      {
         if(this._sceneCharacterStateItem)
         {
            this._sceneCharacterStateItem.sceneCharacterBase.update();
         }
      }
      
      public function get sceneCharacterStateType() : String
      {
         return this._sceneCharacterStateType;
      }
      
      public function set sceneCharacterStateType(param1:String) : void
      {
         if(this._sceneCharacterStateType == param1 && !this.loadComplete)
         {
            return;
         }
         this.loadComplete = false;
         this._sceneCharacterStateType = param1;
         if(!this._sceneCharacterStateSet)
         {
            return;
         }
         this._sceneCharacterStateItem = this._sceneCharacterStateSet.getItem(this._sceneCharacterStateType);
         if(!this._sceneCharacterStateItem)
         {
            return;
         }
         while(this.character && this.character.numChildren > 0)
         {
            this.character.removeChildAt(0);
         }
         this.character.addChild(this._sceneCharacterStateItem.sceneCharacterBase);
      }
      
      public function get sceneCharacterDirection() : SceneCharacterDirection
      {
         return this._sceneCharacterDirection;
      }
      
      public function set sceneCharacterDirection(param1:SceneCharacterDirection) : void
      {
         if(this._sceneCharacterDirection == param1)
         {
            return;
         }
         this._sceneCharacterDirection = param1;
         if(this._sceneCharacterStateItem)
         {
            this._sceneCharacterStateItem.sceneCharacterDirection = this._sceneCharacterDirection;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(this._walkPath && this._walkPath.length > 0)
         {
            this._walkPath.shift();
         }
         this._walkPath = null;
         if(this._tween)
         {
            this._tween.dispose();
         }
         this._tween = null;
         this._sceneCharacterDirection = null;
         this._callBack = null;
         while(this._sceneCharacterStateSet && this._sceneCharacterStateSet.dataSet && this._sceneCharacterStateSet.length > 0)
         {
            this._sceneCharacterStateSet.dataSet[0].dispose();
            this._sceneCharacterStateSet.dataSet.shift();
         }
         this._sceneCharacterStateSet = null;
         if(this._sceneCharacterStateItem)
         {
            this._sceneCharacterStateItem.dispose();
         }
         this._sceneCharacterStateItem = null;
         if(this.character)
         {
            if(this.character.parent)
            {
               this.character.parent.removeChild(this.character);
            }
         }
         this.character = null;
      }
   }
}

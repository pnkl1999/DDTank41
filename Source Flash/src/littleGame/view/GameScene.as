package littleGame.view
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import littleGame.LittleGameManager;
   import littleGame.actions.LittleLivingBornAction;
   import littleGame.data.Grid;
   import littleGame.data.Node;
   import littleGame.events.LittleGameEvent;
   import littleGame.events.LittleLivingEvent;
   import littleGame.model.LittleLiving;
   import littleGame.model.LittlePlayer;
   import littleGame.model.LittleSelf;
   import littleGame.model.Scenario;
   import road7th.utils.MovieClipWrapper;
   
   public class GameScene extends Sprite implements Disposeable
   {
       
      
      private var _game:Scenario;
      
      private var _background:DisplayObject;
      
      private var _foreground:DisplayObject;
      
      private var _backLivingLayer:Sprite;
      
      private var _foreLivingLayer:Sprite;
      
      private var _debug:Boolean = false;
      
      private var _cameraRect:Rectangle;
      
      private var _x:Number = 0;
      
      private var _y:Number = 0;
      
      private var _gameLivings:Dictionary;
      
      private var _left:int;
      
      private var _right:int;
      
      private var _top:int;
      
      private var _bottom:int;
      
      private var shouldRender:Boolean = true;
      
      private var selfGameLiving:GameLittleSelf;
      
      private var selfPos:Point;
      
      private var otherPos:Point;
      
      private var CONST_DISTANCE:Number;
      
      private var dt:Number = 0;
      
      public function GameScene(game:Scenario)
      {
         this.selfPos = new Point();
         this.otherPos = new Point();
         super();
         this._game = game;
         this._cameraRect = new Rectangle(300,250,300,150);
         this._left = StageReferance.stageWidth - this._game.grid.width;
         this._right = 0;
         this._top = StageReferance.stageHeight - this._game.grid.height;
         this._bottom = 0;
         this._gameLivings = new Dictionary();
         this.CONST_DISTANCE = Point.distance(new Point(),new Point(StageReferance.stageHeight,StageReferance.stageHeight));
         this.configUI();
         this.addEvent();
         this._backLivingLayer.mouseEnabled = false;
         this._foreLivingLayer.mouseEnabled = false;
      }
      
      private function configUI() : void
      {
         this.drawScene();
         this._backLivingLayer = new Sprite();
         addChildAt(this._backLivingLayer,getChildIndex(this._foreground));
         this._foreLivingLayer = new Sprite();
         addChild(this._foreLivingLayer);
         this.drawLivings();
         if(this._debug)
         {
            this.drawGrid();
         }
      }
      
      private function drawLivings() : void
      {
         var living:LittleLiving = null;
         var livings:Dictionary = this._game.livings;
         for each(living in livings)
         {
            this.drawLiving(living);
         }
      }
      
      private function drawLiving(living:LittleLiving) : GameLittleLiving
      {
         var gameLiving:GameLittleLiving = null;
         if(living.isSelf)
         {
            gameLiving = new GameLittleSelf(living as LittleSelf);
            this.selfGameLiving = gameLiving as GameLittleSelf;
            living.addEventListener(LittleLivingEvent.PosChenged,this.__selfPosChanged);
            this.focusSelf(living);
         }
         else if(living.isPlayer)
         {
            gameLiving = new GameLittlePlayer(living as LittlePlayer);
         }
         else
         {
            gameLiving = new GameLittleLiving(living);
         }
         this._backLivingLayer.addChild(gameLiving);
         this._gameLivings[living.id] = gameLiving;
         this.sortLiving(gameLiving);
         return gameLiving;
      }
      
      private function onLivingClicked(event:MouseEvent) : void
      {
         event.stopPropagation();
         var self:LittleSelf = this._game.selfPlayer;
         var gameliving:GameLittleLiving = event.currentTarget as GameLittleLiving;
         var dx:int = gameliving.living.pos.x * gameliving.living.speed / this._game.grid.cellSize;
         var dy:int = gameliving.living.pos.y * gameliving.living.speed / this._game.grid.cellSize;
         var path:Array = LittleGameManager.Instance.fillPath(self,this._game.grid,self.pos.x,self.pos.y,dx,dy);
         if(path)
         {
         }
      }
      
      private function drawGrid() : void
      {
         var cols:int = 0;
         var j:int = 0;
         var grid:Grid = this._game.grid;
         var bitmapData:BitmapData = new BitmapData(grid.width,grid.height,true,0);
         var nodes:Array = grid.nodes;
         var rows:int = nodes.length;
         for(var i:int = 0; i < rows; i++)
         {
            cols = nodes[i].length;
            for(j = 0; j < cols; j++)
            {
               if(!nodes[i][j].walkable)
               {
                  bitmapData.fillRect(new Rectangle(j * grid.cellSize,i * grid.cellSize,grid.cellSize,grid.cellSize),2583625728);
               }
            }
         }
         addChild(new Bitmap(bitmapData));
      }
      
      private function drawScene() : void
      {
         this._background = ClassUtils.CreatInstance("asset.littleGame.back" + this._game.id);
         addChild(this._background);
         this._foreground = ClassUtils.CreatInstance("asset.littleGame.fore" + this._game.id);
         if(this._foreground is DisplayObjectContainer)
         {
            DisplayObjectContainer(this._foreground).mouseEnabled = false;
            DisplayObjectContainer(this._foreground).mouseChildren = false;
         }
         addChild(this._foreground);
      }
      
      private function addEvent() : void
      {
         this._game.addEventListener(LittleGameEvent.AddLiving,this.__addLiving);
         this._game.addEventListener(LittleGameEvent.Update,this.__update);
         this._game.addEventListener(LittleGameEvent.RemoveLiving,this.__removeLiving);
         addEventListener(MouseEvent.CLICK,this.__click);
      }
      
      private function __mouseDown(event:MouseEvent) : void
      {
         startDrag();
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
      }
      
      private function __mouseUp(event:MouseEvent) : void
      {
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         stopDrag();
      }
      
      private function __removeLiving(event:LittleGameEvent) : void
      {
         var living:LittleLiving = event.paras[0] as LittleLiving;
         var gameLiving:GameLittleLiving = this._gameLivings[living.id];
         gameLiving.removeEventListener(MouseEvent.CLICK,this.onLivingClicked);
         ObjectUtils.disposeObject(gameLiving);
         delete this._gameLivings[living.id];
      }
      
      private function __update(event:LittleGameEvent) : void
      {
         this.updateLivingVisible();
         this.sortDepth();
      }
      
      private function sortDepth() : void
      {
         var child:DisplayObject = null;
         var arr:Array = new Array();
         for(var i:int = 0; i < this._backLivingLayer.numChildren; i++)
         {
            child = this._backLivingLayer.getChildAt(i);
            if(child is GameLittleLiving && !GameLittleLiving(child).lock)
            {
               arr.push(child);
            }
            else
            {
               arr.push(child);
            }
         }
         arr.sortOn(["y"],[Array.NUMERIC]);
         for(var j:int = 0; j < arr.length; j++)
         {
            this._backLivingLayer.setChildIndex(arr[j],j);
         }
      }
      
      private function updateLivingVisible() : void
      {
         var gameLiving:GameLittleLiving = null;
         if(this.selfGameLiving)
         {
            this.selfPos.x = this.selfGameLiving.x;
            this.selfPos.y = this.selfGameLiving.y;
            for each(gameLiving in this._gameLivings)
            {
               this.otherPos.x = gameLiving.x;
               this.otherPos.y = gameLiving.y;
               this.shouldRender = Point.distance(this.selfPos,this.otherPos) < this.CONST_DISTANCE;
               if(this.shouldRender || gameLiving.lock)
               {
                  gameLiving.realRender = true;
                  if(!gameLiving.lock)
                  {
                     this._backLivingLayer.addChild(gameLiving);
                  }
               }
               else
               {
                  gameLiving.realRender = false;
                  if(this._backLivingLayer.contains(gameLiving))
                  {
                     this._backLivingLayer.removeChild(gameLiving);
                  }
               }
            }
         }
      }
      
      private function sortLiving(gameLiving:GameLittleLiving) : void
      {
         var stone:Rectangle = null;
         var bounds:Rectangle = gameLiving.getBounds(this);
         var stones:Vector.<Rectangle> = this._game.stones;
         for each(stone in stones)
         {
            if(stone.intersects(bounds))
            {
               if(bounds.bottom <= stone.bottom)
               {
                  this._backLivingLayer.addChild(gameLiving);
               }
               else
               {
                  this._foreLivingLayer.addChild(gameLiving);
               }
            }
         }
      }
      
      private function __selfPosChanged(event:LittleLivingEvent) : void
      {
         var self:LittleLiving = event.currentTarget as LittleLiving;
         var oldPos:Point = new Point(event.paras[0].x * self.speed,event.paras[0].y * self.speed);
         var newPos:Point = new Point(self.pos.x * self.speed,self.pos.y * self.speed);
         var globalPos:Point = localToGlobal(newPos);
         if(newPos.y > oldPos.y && globalPos.y > this._cameraRect.bottom)
         {
            this.y = y + (oldPos.y - newPos.y);
         }
         else if(newPos.y < oldPos.y && globalPos.y < this._cameraRect.top)
         {
            this.y = y + (oldPos.y - newPos.y);
         }
         if(newPos.x > oldPos.x && globalPos.x > this._cameraRect.right)
         {
            this.x = x + (oldPos.x - newPos.x);
         }
         else if(newPos.x < oldPos.x && globalPos.x < this._cameraRect.left)
         {
            this.x = x + (oldPos.x - newPos.x);
         }
      }
      
      public function drawServPath(living:LittleLiving) : void
      {
         var path:Array = living.servPath;
         var g:Graphics = this._foreLivingLayer.graphics;
         g.clear();
         var node:Node = path[0];
         g.lineStyle(2,255);
         g.moveTo(node.x * this._game.grid.cellSize,node.y * this._game.grid.cellSize);
         var len:int = path.length;
         ChatManager.Instance.sysChatYellow("drawServPath:" + len);
         for(var i:int = 1; i < len; i++)
         {
            g.lineTo(path[i].x * this._game.grid.cellSize,path[i].y * this._game.grid.cellSize);
         }
         g.endFill();
      }
      
      override public function set x(value:Number) : void
      {
         if(value >= this._left && value <= this._right)
         {
            super.x = value;
         }
      }
      
      override public function set y(value:Number) : void
      {
         if(value >= this._top && value <= this._bottom)
         {
            super.y = value;
         }
      }
      
      private function __click(event:MouseEvent) : void
      {
         var mc:MovieClipWrapper = null;
         var self:LittleSelf = this._game.selfPlayer;
         var dx:int = mouseX / this._game.grid.cellSize;
         var dy:int = mouseY / this._game.grid.cellSize;
         var path:Array = LittleGameManager.Instance.fillPath(self,this._game.grid,self.pos.x,self.pos.y,dx,dy);
         if(path)
         {
            LittleGameManager.Instance.selfMoveTo(this._game,self,self.pos.x,self.pos.y,dx,dy,this._game.clock.time,path);
            mc = new MovieClipWrapper(ClassUtils.CreatInstance("asset.hotSpring.MouseClickMovie"),true,true);
            mc.movie.mouseEnabled = false;
            mc.movie.mouseChildren = false;
            mc.x = mouseX;
            mc.y = mouseY;
            addChild(mc.movie);
         }
      }
      
      public function findGameLiving(id:int) : GameLittleLiving
      {
         return this._gameLivings[id];
      }
      
      public function __addLiving(event:LittleGameEvent) : void
      {
         var gameLiving:GameLittleLiving = this.drawLiving(event.paras[0]);
         if(!gameLiving.living.isPlayer)
         {
            gameLiving.living.act(new LittleLivingBornAction(gameLiving.living));
         }
      }
      
      private function focusSelf(self:LittleLiving) : void
      {
         var global:Point = localToGlobal(new Point(self.pos.x * self.speed,self.pos.y * self.speed));
         this.x = (StageReferance.stageWidth >> 1) - global.x;
         this.y = (StageReferance.stageWidth >> 1) - global.y;
      }
      
      private function removeEvent() : void
      {
         var gameliving:GameLittleLiving = null;
         for each(gameliving in this._gameLivings)
         {
            gameliving.removeEventListener(MouseEvent.CLICK,this.onLivingClicked);
         }
         this._game.removeEventListener(LittleGameEvent.AddLiving,this.__addLiving);
         this._game.removeEventListener(LittleGameEvent.Update,this.__update);
         this._game.removeEventListener(LittleGameEvent.RemoveLiving,this.__removeLiving);
         removeEventListener(MouseEvent.CLICK,this.__click);
      }
      
      public function addToLayer(object:DisplayObject, layer:int) : void
      {
         var container:DisplayObjectContainer = this.getLayer(layer);
         if(container)
         {
            container.addChild(object);
         }
      }
      
      public function getLayer(layer:int) : DisplayObjectContainer
      {
         switch(layer)
         {
            case LittleGameManager.GameBackLayer:
               return this._backLivingLayer;
            case LittleGameManager.GameForeLayer:
               return this._foreLivingLayer;
            default:
               return null;
         }
      }
      
      public function dispose() : void
      {
         var key:* = null;
         var gameLiving:GameLittleLiving = null;
         this.removeEvent();
         if(parent)
         {
            parent.removeChild(this);
         }
         for(key in this._gameLivings)
         {
            gameLiving = this._gameLivings[key];
            ObjectUtils.disposeObject(gameLiving);
            delete this._gameLivings[key];
         }
         this._game = null;
         ObjectUtils.disposeObject(this._background);
         ObjectUtils.disposeObject(this._foreground);
         ObjectUtils.disposeObject(this._backLivingLayer);
         ObjectUtils.disposeObject(this._foreLivingLayer);
         this.selfGameLiving = null;
         this._background = null;
         this._foreground = null;
         this._backLivingLayer = null;
         this._foreLivingLayer = null;
      }
   }
}

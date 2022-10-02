package ddt.view.caddyII
{
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Elastic;
   import com.greensock.easing.Linear;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.media.Video;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import road7th.utils.MovieClipWrapper;
   
   public class CaddyTurn extends Sprite implements Disposeable
   {
      
      public static const TURN_COMPLETE:String = "caddy_turn_complete";
      
      public static const TIMER_DELAY:int = 100;
       
      
      private var _turnSprite:Sprite;
      
      private var _selectSprite:Sprite;
      
      private var _selectedCell:BaseCell;
      
      private var _cellNow:BaseCell;
      
      private var _goodsNameTxt:FilterFrameText;
      
      private var _selectedGoodsInfo:InventoryItemInfo;
      
      private var _cells:Vector.<BaseCell>;
      
      private var _templateIDList:Vector.<int>;
      
      private var _timer:Timer;
      
      private var _showCellAble:Boolean = false;
      
      private var _cellNumber:int = 0;
      
      private var _movie:MovieClip;
      
      private var _turnStartFrame:int;
      
      private var _showItemFrame:int;
      
      private var _turnEndFrame:int;
      
      private var _itemsScale:Number = 0.9;
      
      private var _getMovie:MovieClipWrapper;
      
      private var _box:ItemTemplateInfo;
      
      private var _caddyType:int = 1;
      
      public function CaddyTurn(param1:FilterFrameText)
      {
         super();
         this.init(param1);
         this.initEvents();
      }
      
      public function setCaddyType(param1:int) : void
      {
         if(this._caddyType != param1)
         {
            this._caddyType = param1;
            this.configMovie();
         }
      }
      
      private function configMovie() : void
      {
         var _loc1_:MovieClip = this._movie;
         if(this._caddyType == CaddyModel.Gold_Caddy)
         {
            this._movie = ComponentFactory.Instance.creat("ddt.view.caddyII.Gold_videoAsset");
         }
         else if(this._caddyType == CaddyModel.Silver_Caddy)
         {
            this._movie = ComponentFactory.Instance.creat("ddt.view.caddyII.Silver_videoAsset");
         }
         else
         {
            this._movie = ComponentFactory.Instance.creat("ddt.view.caddyII.videoAsset");
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._movie.currentLabels.length)
         {
            if(this._movie.currentLabels[_loc2_].name == "turn")
            {
               this._turnStartFrame = this._movie.currentLabels[_loc2_].frame;
            }
            else if(this._movie.currentLabels[_loc2_].name == "showItems")
            {
               this._showItemFrame = this._movie.currentLabels[_loc2_].frame;
            }
            else if(this._movie.currentLabels[_loc2_].name == "turnEnd")
            {
               this._turnEndFrame = this._movie.currentLabels[_loc2_].frame;
            }
            _loc2_++;
         }
         PositionUtils.setPos(this._movie,"caddy.moviePos");
         addChildAt(this._movie,0);
         if(_loc1_ && _loc1_ != this._movie)
         {
            _loc1_.removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
            this.disposeMovie(_loc1_);
            ObjectUtils.disposeObject(_loc1_);
         }
      }
      
      private function init(param1:FilterFrameText) : void
      {
         this.configMovie();
         this._getMovie = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("MovieGet"));
         this._getMovie.stop();
         addChild(this._getMovie.movie);
         this._turnSprite = ComponentFactory.Instance.creatCustomObject("caddy.turnSprite");
         addChild(this._turnSprite);
         this._goodsNameTxt = param1;
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("caddy.selectCellSize");
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.beginFill(16777215,0);
         _loc3_.graphics.drawRect(0,0,_loc2_.x,_loc2_.y);
         _loc3_.graphics.endFill();
         this._selectSprite = ComponentFactory.Instance.creatCustomObject("caddy.turnSprite");
         this._selectedCell = new BaseCell(_loc3_);
         this._selectedCell.x = this._selectedCell.width / -2;
         this._selectedCell.y = this._selectedCell.height / -2;
         this._selectSprite.addChild(this._selectedCell);
         addChild(this._selectSprite);
         this._timer = new Timer(TIMER_DELAY);
         this._timer.stop();
         this._cells = new Vector.<BaseCell>();
      }
      
      private function initEvents() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER,this._oneComplete);
      }
      
      private function removeEvens() : void
      {
         this._movie.removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._timer.removeEventListener(TimerEvent.TIMER,this._oneComplete);
         this._getMovie.removeEventListener(Event.COMPLETE,this.__getMovieComplete);
      }
      
      private function createCells() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:BaseCell = null;
         _loc1_ = 0;
         _loc2_ = 0;
         _loc3_ = null;
         var _loc4_:BaseCell = null;
         this._cells = new Vector.<BaseCell>();
         _loc1_ = Math.floor(Math.random() * this._templateIDList.length);
         _loc2_ = 0;
         while(_loc2_ < this._templateIDList.length)
         {
            _loc3_ = new BaseCell(ComponentFactory.Instance.creatBitmap("asset.caddy.caddyCellBG"));
            _loc3_.info = ItemManager.Instance.getTemplateById(this._templateIDList[_loc2_]);
            _loc3_.x = _loc3_.width / -2;
            _loc3_.y = _loc3_.height / -2;
            this._turnSprite.addChild(_loc3_);
            _loc3_.visible = false;
            if(_loc2_ == _loc1_)
            {
               _loc4_ = new BaseCell(ComponentFactory.Instance.creatBitmap("asset.caddy.caddyCellBG"));
               _loc4_.info = this._selectedGoodsInfo;
               _loc4_.x = _loc4_.width / -2;
               _loc4_.y = _loc4_.height / -2;
               this._turnSprite.addChild(_loc4_);
               this._cells.push(_loc4_);
               _loc4_.visible = false;
            }
            this._cells.push(_loc3_);
            _loc2_++;
         }
         this._turnSprite.scaleX = this._itemsScale;
         this._turnSprite.scaleY = this._itemsScale;
      }
      
      private function _oneComplete(param1:TimerEvent) : void
      {
         this._cells[this._cellNumber].visible = !!this._showCellAble ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         if(this._cellNow == null)
         {
            this._cellNow = this._cells[this._cellNumber];
         }
         else
         {
            this._cellNow.visible = false;
            this._cellNow = this._cells[this._cellNumber];
         }
         ++this._cellNumber;
         if(this._cellNumber >= this._cells.length)
         {
            this._cellNumber = 0;
         }
         this._goodsNameTxt.text = this._cellNow.info.Name;
      }
      
      private function _timeOut() : void
      {
         this._clear();
         dispatchEvent(new Event(TURN_COMPLETE));
      }
      
      public function again() : void
      {
         this._movie.gotoAndPlay(1);
      }
      
      private function turn() : void
      {
         if(this._box.TemplateID == EquipType.CADDY)
         {
            TweenLite.to(this._turnSprite,2.5,{
               "rotationX":-360 * 5,
               "ease":Linear.easeNone
            });
         }
         else
         {
            TweenLite.to(this._turnSprite,3.5,{
               "rotationX":-360 * 5,
               "ease":Linear.easeNone
            });
         }
      }
      
      private function creatTweenMagnify(param1:Number = 1, param2:Number = 1.5, param3:int = -1, param4:Boolean = true, param5:int = 1100) : void
      {
         if(this._caddyType == CaddyModel.Gold_Caddy)
         {
            TweenMax.to(this._selectSprite,param1,{
               "scaleX":param2,
               "scaleY":param2,
               "repeat":param3,
               "yoyo":param4
            });
         }
         else
         {
            TweenMax.to(this._selectSprite,param1,{
               "scaleX":param2,
               "scaleY":param2,
               "repeat":param3,
               "yoyo":param4,
               "ease":Elastic.easeOut
            });
            setTimeout(this._timeOut,param5);
         }
      }
      
      private function _clear() : void
      {
         var _loc1_:BaseCell = null;
         this._selectedGoodsInfo = null;
         this._templateIDList = null;
         for each(_loc1_ in this._cells)
         {
            ObjectUtils.disposeObject(_loc1_);
         }
         this._cells = null;
         TweenMax.killTweensOf(this._selectSprite);
         if(this._selectedCell)
         {
            this._selectedCell.visible = false;
         }
         if(this._selectSprite)
         {
            this._selectSprite.scaleX = this._selectSprite.scaleY = 1;
         }
         if(this._goodsNameTxt)
         {
            this._goodsNameTxt.text = "";
         }
      }
      
      public function setTurnInfo(param1:InventoryItemInfo, param2:Vector.<int>) : void
      {
         this._selectedGoodsInfo = param1;
         this._templateIDList = param2;
         this.createCells();
      }
      
      public function start(param1:ItemTemplateInfo) : void
      {
         this._box = param1;
         if(this._box.TemplateID == EquipType.CADDY)
         {
            SoundManager.instance.play("155");
         }
         else
         {
            SoundManager.instance.play("137");
         }
         this._movie.addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._movie.gotoAndPlay(this._turnStartFrame);
         this.showItems();
         this._showCellAble = false;
         this._turnSprite.visible = true;
      }
      
      private function __frameHandler(param1:Event) : void
      {
         if(this._movie.currentFrame == this._showItemFrame)
         {
            this._showCellAble = true;
            this.turn();
         }
         else if(this._movie.currentFrame == this._turnEndFrame)
         {
            this._movie.gotoAndStop(this._turnEndFrame + 1);
            this._timer.stop();
            this._turnSprite.visible = false;
            this._selectedCell.info = this._selectedGoodsInfo;
            this._selectedCell.visible = true;
            TweenLite.killDelayedCallsTo(this._turnSprite);
            this._turnSprite.rotationX = 0;
            this._turnSprite.scaleX = 1;
            this._turnSprite.scaleY = 1;
            if(this._caddyType == CaddyModel.Gold_Caddy)
            {
               this._getMovie.movie.visible = true;
               this._getMovie.gotoAndPlay(1);
               this._getMovie.addEventListener(Event.COMPLETE,this.__getMovieComplete);
               TweenMax.to(this._selectSprite,0.5,{
                  "scaleX":2,
                  "scaleY":2,
                  "onComplete":this.getTweenComplete
               });
            }
            else
            {
               this._goodsNameTxt.text = this._selectedCell.info.Name;
               this.creatTweenMagnify();
            }
         }
      }
      
      private function getTweenComplete() : void
      {
         this._goodsNameTxt.text = this._selectedCell.info.Name;
         this._selectSprite.scaleY = 1.8;
         this._selectSprite.scaleX = 1.8;
         this.creatTweenMagnify(1,2,-1,true,3500);
      }
      
      private function __getMovieComplete(param1:Event) : void
      {
         this._getMovie.removeEventListener(Event.COMPLETE,this.__getMovieComplete);
         this._getMovie.movie.visible = false;
         this._timeOut();
      }
      
      private function showItems() : void
      {
         this._timer.reset();
         this._timer.start();
      }
      
      private function disposeMovie(param1:DisplayObjectContainer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         if(param1 != null)
         {
            if(param1 is MovieClip)
            {
               MovieClip(param1).gotoAndStop(1);
            }
            _loc2_ = param1.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = param1.getChildAt(_loc3_);
               if(_loc4_ is Video)
               {
                  Video(_loc4_).clear();
               }
               _loc3_++;
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvens();
         if(this._turnSprite)
         {
            ObjectUtils.disposeObject(this._turnSprite);
         }
         this._turnSprite = null;
         if(this._selectSprite)
         {
            ObjectUtils.disposeObject(this._selectSprite);
         }
         this._selectSprite = null;
         if(this._selectedCell)
         {
            ObjectUtils.disposeObject(this._selectedCell);
         }
         this._selectedCell = null;
         if(this._cellNow)
         {
            ObjectUtils.disposeObject(this._cellNow);
         }
         this._cellNow = null;
         if(this._movie)
         {
            this.disposeMovie(this._movie);
         }
         ObjectUtils.disposeObject(this._movie);
         this._movie = null;
         if(this._getMovie)
         {
            ObjectUtils.disposeObject(this._getMovie);
         }
         this._getMovie = null;
         if(this._timer)
         {
            this._timer.stop();
            this._timer = null;
         }
         var _loc1_:int = 0;
         while(this._cells && _loc1_ < this._cells.length)
         {
            ObjectUtils.disposeObject(this._cells[_loc1_]);
            _loc1_++;
         }
         this._cells = null;
         this._goodsNameTxt = null;
         this._selectedGoodsInfo = null;
         this._templateIDList = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

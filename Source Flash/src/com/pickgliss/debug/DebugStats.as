package com.pickgliss.debug
{
   import flash.display.BitmapData;
   import flash.display.CapsStyle;
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class DebugStats extends Sprite
   {
      
      private static const _WIDTH:Number = 125;
      
      private static const _MAX_HEIGHT:Number = 75;
      
      private static const _MIN_HEIGHT:Number = 41;
      
      private static const _UPPER_Y:Number = -1;
      
      private static const _LOWER_Y:Number = 9;
      
      private static const _POLY_COL:uint = 16763904;
      
      private static const _MEM_COL:uint = 16711884;
      
      private static var _INSTANCE:DebugStats;
       
      
      private var _timer:Timer;
      
      private var _last_frame_timestamp:Number;
      
      private var _fps:uint;
      
      private var _ram:Number;
      
      private var _max_ram:Number;
      
      private var _min_fps:uint;
      
      private var _avg_fps:Number;
      
      private var _max_fps:uint;
      
      private var _tfaces:uint;
      
      private var _rfaces:uint;
      
      private var _num_frames:uint;
      
      private var _fps_sum:uint;
      
      private var _top_bar:Sprite;
      
      private var _btm_bar:Sprite;
      
      private var _btm_bar_hit:Sprite;
      
      private var _data_format:TextFormat;
      
      private var _label_format:TextFormat;
      
      private var _fps_bar:Shape;
      
      private var _afps_bar:Shape;
      
      private var _lfps_bar:Shape;
      
      private var _hfps_bar:Shape;
      
      private var _diagram:Sprite;
      
      private var _dia_bmp:BitmapData;
      
      private var _mem_points:Array;
      
      private var _mem_graph:Shape;
      
      private var _updates:int;
      
      private var _min_max_btn:Sprite;
      
      private var _fps_tf:TextField;
      
      private var _afps_tf:TextField;
      
      private var _ram_tf:TextField;
      
      private var _poly_tf:TextField;
      
      private var _drag_dx:Number;
      
      private var _drag_dy:Number;
      
      private var _dragging:Boolean;
      
      private var _mean_data:Array;
      
      private var _mean_data_length:int;
      
      private var _enable_reset:Boolean;
      
      private var _enable_mod_fr:Boolean;
      
      private var _transparent:Boolean;
      
      private var _minimized:Boolean;
      
      public function DebugStats(param1:Boolean = false, param2:Boolean = false, param3:uint = 0, param4:Boolean = true, param5:Boolean = true)
      {
         super();
         this._minimized = param1;
         this._transparent = param2;
         this._enable_reset = param4;
         this._enable_mod_fr = param5;
         this._mean_data_length = param3;
         if(_INSTANCE)
         {
         }
         _INSTANCE = this;
         this._fps = 0;
         this._num_frames = 0;
         this._avg_fps = 0;
         this._ram = 0;
         this._max_ram = 0;
         this._tfaces = 0;
         this._rfaces = 0;
         this._init();
      }
      
      public static function get instance() : DebugStats
      {
         return _INSTANCE;
      }
      
      public function get fps() : int
      {
         return this._fps;
      }
      
      private function _init() : void
      {
         this._initMisc();
         this._initTopBar();
         this._initBottomBar();
         this._initDiagrams();
         this._initInteraction();
         this._reset();
         this._redrawWindow();
         addEventListener(Event.ADDED_TO_STAGE,this._onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this._onRemovedFromStage);
      }
      
      private function _initMisc() : void
      {
         var _loc1_:int = 0;
         this._timer = new Timer(200,0);
         this._timer.addEventListener("timer",this._onTimer);
         this._label_format = new TextFormat("_sans",9,16777215,true);
         this._data_format = new TextFormat("_sans",9,16777215,false);
         if(this._mean_data_length > 0)
         {
            this._mean_data = [];
            _loc1_ = 0;
            while(_loc1_ < this._mean_data_length)
            {
               this._mean_data[_loc1_] = 0;
               _loc1_++;
            }
         }
      }
      
      private function _initTopBar() : void
      {
         var _loc1_:Shape = null;
         var _loc2_:Shape = null;
         var _loc3_:TextField = null;
         var _loc4_:TextField = null;
         this._top_bar = new Sprite();
         this._top_bar.graphics.beginFill(0,0);
         this._top_bar.graphics.drawRect(0,0,_WIDTH,20);
         addChild(this._top_bar);
         _loc1_ = new Shape();
         _loc1_.x = 9;
         _loc1_.y = 7.5;
         _loc1_.scaleX = 0.6;
         _loc1_.scaleY = 0.6;
         _loc1_.graphics.beginFill(16777215,1);
         _loc1_.graphics.moveTo(-0.5,-7);
         _loc1_.graphics.curveTo(-0.5,-7.7,-1,-7);
         _loc1_.graphics.lineTo(-9,5);
         _loc1_.graphics.curveTo(-9.3,5.5,-8,5);
         _loc1_.graphics.curveTo(-1,1,-0.5,-7);
         _loc1_.graphics.moveTo(0.5,-7);
         _loc1_.graphics.curveTo(0.5,-7.7,1,-7);
         _loc1_.graphics.lineTo(9,5);
         _loc1_.graphics.curveTo(9.3,5.5,8,5);
         _loc1_.graphics.curveTo(1,1,0.5,-7);
         _loc1_.graphics.moveTo(-8,7);
         _loc1_.graphics.curveTo(-8.3,6.7,-7.5,6.3);
         _loc1_.graphics.curveTo(0,2,7.5,6.3);
         _loc1_.graphics.curveTo(8.3,6.7,8,7);
         _loc1_.graphics.lineTo(-8,7);
         this._top_bar.addChild(_loc1_);
         _loc2_ = new Shape();
         _loc2_.graphics.beginFill(16777215);
         _loc2_.graphics.drawRect(20,7,4,4);
         _loc2_.graphics.beginFill(3377373);
         _loc2_.graphics.drawRect(77,7,4,4);
         this._top_bar.addChild(_loc2_);
         _loc3_ = new TextField();
         _loc3_.defaultTextFormat = this._label_format;
         _loc3_.autoSize = TextFieldAutoSize.LEFT;
         _loc3_.text = "FR:";
         _loc3_.x = 24;
         _loc3_.y = 2;
         _loc3_.selectable = false;
         this._top_bar.addChild(_loc3_);
         this._fps_tf = new TextField();
         this._fps_tf.defaultTextFormat = this._data_format;
         this._fps_tf.autoSize = TextFieldAutoSize.LEFT;
         this._fps_tf.x = _loc3_.x + 16;
         this._fps_tf.y = _loc3_.y;
         this._fps_tf.selectable = false;
         this._top_bar.addChild(this._fps_tf);
         _loc4_ = new TextField();
         _loc4_.defaultTextFormat = this._label_format;
         _loc4_.autoSize = TextFieldAutoSize.LEFT;
         _loc4_.text = "A:";
         _loc4_.x = 81;
         _loc4_.y = 2;
         _loc4_.selectable = false;
         this._top_bar.addChild(_loc4_);
         this._afps_tf = new TextField();
         this._afps_tf.defaultTextFormat = this._data_format;
         this._afps_tf.autoSize = TextFieldAutoSize.LEFT;
         this._afps_tf.x = _loc4_.x + 12;
         this._afps_tf.y = _loc4_.y;
         this._afps_tf.selectable = false;
         this._top_bar.addChild(this._afps_tf);
         this._min_max_btn = new Sprite();
         this._min_max_btn.x = _WIDTH - 8;
         this._min_max_btn.y = 7;
         this._min_max_btn.graphics.beginFill(0,0);
         this._min_max_btn.graphics.lineStyle(1,15724527,1,true);
         this._min_max_btn.graphics.drawRect(-4,-4,8,8);
         this._min_max_btn.graphics.moveTo(-3,2);
         this._min_max_btn.graphics.lineTo(3,2);
         this._min_max_btn.buttonMode = true;
         this._min_max_btn.addEventListener(MouseEvent.CLICK,this._onMinMaxBtnClick);
         this._top_bar.addChild(this._min_max_btn);
      }
      
      private function _initBottomBar() : void
      {
         var _loc1_:Shape = null;
         var _loc2_:TextField = null;
         var _loc3_:TextField = null;
         this._btm_bar = new Sprite();
         this._btm_bar.graphics.beginFill(0,0.2);
         this._btm_bar.graphics.drawRect(0,0,_WIDTH,21);
         addChild(this._btm_bar);
         this._btm_bar_hit = new Sprite();
         this._btm_bar_hit.graphics.beginFill(16763904,0);
         this._btm_bar_hit.graphics.drawRect(0,1,_WIDTH,20);
         addChild(this._btm_bar_hit);
         _loc1_ = new Shape();
         _loc1_.graphics.beginFill(_MEM_COL);
         _loc1_.graphics.drawRect(5,4,4,4);
         _loc1_.graphics.beginFill(_POLY_COL);
         _loc1_.graphics.drawRect(5,14,4,4);
         this._btm_bar.addChild(_loc1_);
         _loc2_ = new TextField();
         _loc2_.defaultTextFormat = this._label_format;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.text = "RAM:";
         _loc2_.x = 10;
         _loc2_.y = _UPPER_Y;
         _loc2_.selectable = false;
         _loc2_.mouseEnabled = false;
         this._btm_bar.addChild(_loc2_);
         this._ram_tf = new TextField();
         this._ram_tf.defaultTextFormat = this._data_format;
         this._ram_tf.autoSize = TextFieldAutoSize.LEFT;
         this._ram_tf.x = _loc2_.x + 31;
         this._ram_tf.y = _loc2_.y;
         this._ram_tf.selectable = false;
         this._ram_tf.mouseEnabled = false;
         this._btm_bar.addChild(this._ram_tf);
         _loc3_ = new TextField();
         _loc3_.defaultTextFormat = this._label_format;
         _loc3_.autoSize = TextFieldAutoSize.LEFT;
         _loc3_.text = "POLY:";
         _loc3_.x = 10;
         _loc3_.y = _LOWER_Y;
         _loc3_.selectable = false;
         _loc3_.mouseEnabled = false;
         this._btm_bar.addChild(_loc3_);
         this._poly_tf = new TextField();
         this._poly_tf.defaultTextFormat = this._data_format;
         this._poly_tf.autoSize = TextFieldAutoSize.LEFT;
         this._poly_tf.x = _loc3_.x + 31;
         this._poly_tf.y = _loc3_.y;
         this._poly_tf.selectable = false;
         this._poly_tf.mouseEnabled = false;
         this._btm_bar.addChild(this._poly_tf);
      }
      
      private function _initDiagrams() : void
      {
         this._dia_bmp = new BitmapData(_WIDTH,_MAX_HEIGHT - 40,true,0);
         this._diagram = new Sprite();
         this._diagram.graphics.beginBitmapFill(this._dia_bmp);
         this._diagram.graphics.drawRect(0,0,this._dia_bmp.width,this._dia_bmp.height);
         this._diagram.graphics.endFill();
         this._diagram.y = 17;
         addChild(this._diagram);
         this._diagram.graphics.lineStyle(1,16777215,0.03);
         this._diagram.graphics.moveTo(0,0);
         this._diagram.graphics.lineTo(_WIDTH,0);
         this._diagram.graphics.moveTo(0,Math.floor(this._dia_bmp.height / 2));
         this._diagram.graphics.lineTo(_WIDTH,Math.floor(this._dia_bmp.height / 2));
         this._fps_bar = new Shape();
         this._fps_bar.graphics.beginFill(16777215);
         this._fps_bar.graphics.drawRect(0,0,_WIDTH,4);
         this._fps_bar.x = 0;
         this._fps_bar.y = 16;
         addChild(this._fps_bar);
         this._afps_bar = new Shape();
         this._afps_bar.graphics.lineStyle(1,3377373,1,false,LineScaleMode.NORMAL,CapsStyle.SQUARE);
         this._afps_bar.graphics.lineTo(0,4);
         this._afps_bar.y = this._fps_bar.y;
         addChild(this._afps_bar);
         this._lfps_bar = new Shape();
         this._lfps_bar.graphics.lineStyle(1,16711680,1,false,LineScaleMode.NORMAL,CapsStyle.SQUARE);
         this._lfps_bar.graphics.lineTo(0,4);
         this._lfps_bar.y = this._fps_bar.y;
         addChild(this._lfps_bar);
         this._hfps_bar = new Shape();
         this._hfps_bar.graphics.lineStyle(1,65280,1,false,LineScaleMode.NORMAL,CapsStyle.SQUARE);
         this._hfps_bar.graphics.lineTo(0,4);
         this._hfps_bar.y = this._fps_bar.y;
         addChild(this._hfps_bar);
         this._mem_points = [];
         this._mem_graph = new Shape();
         this._mem_graph.y = this._diagram.y + this._diagram.height;
         addChildAt(this._mem_graph,0);
      }
      
      private function _initInteraction() : void
      {
         this._top_bar.addEventListener(MouseEvent.MOUSE_DOWN,this._onTopBarMouseDown);
         if(this._enable_reset)
         {
            this._btm_bar.mouseEnabled = false;
            this._btm_bar_hit.addEventListener(MouseEvent.CLICK,this._onCountersClick_reset);
            this._afps_tf.addEventListener(MouseEvent.MOUSE_UP,this._onAverageFpsClick_reset,false,1);
         }
         if(this._enable_mod_fr)
         {
            this._diagram.addEventListener(MouseEvent.CLICK,this._onDiagramClick);
         }
      }
      
      private function _redrawWindow() : void
      {
         var _loc1_:Number = NaN;
         _loc1_ = !!this._minimized ? Number(Number(_MIN_HEIGHT)) : Number(Number(_MAX_HEIGHT));
         if(!this._transparent)
         {
            this.graphics.clear();
            this.graphics.beginFill(0,0.6);
            this.graphics.drawRect(0,0,_WIDTH,_loc1_);
         }
         this._min_max_btn.rotation = !!this._minimized ? Number(Number(180)) : Number(Number(0));
         this._btm_bar.y = _loc1_ - 21;
         this._btm_bar_hit.y = this._btm_bar.y;
         this._diagram.visible = !this._minimized;
         this._mem_graph.visible = !this._minimized;
         this._fps_bar.visible = this._minimized;
         this._afps_bar.visible = this._minimized;
         this._lfps_bar.visible = this._minimized;
         this._hfps_bar.visible = this._minimized;
         if(!this._minimized)
         {
            this._redrawMemGraph();
         }
      }
      
      private function _redrawStats() : void
      {
         var _loc1_:int = 0;
         this._fps_tf.text = this._fps.toString().concat("/",stage.frameRate);
         this._afps_tf.text = Math.round(this._avg_fps).toString();
         this._ram_tf.text = this._getRamString(this._ram).concat(" / ",this._getRamString(this._max_ram));
         this._dia_bmp.scroll(1,0);
         this._poly_tf.text = "n/a (no view)";
         _loc1_ = this._dia_bmp.height - Math.floor(this._fps / stage.frameRate * this._dia_bmp.height);
         this._dia_bmp.setPixel32(1,_loc1_,4294967295);
         _loc1_ = this._dia_bmp.height - Math.floor(this._avg_fps / stage.frameRate * this._dia_bmp.height);
         this._dia_bmp.setPixel32(1,_loc1_,4281580543);
         if(this._minimized)
         {
            this._fps_bar.scaleX = Math.min(1,this._fps / stage.frameRate);
            this._afps_bar.x = Math.min(1,this._avg_fps / stage.frameRate) * _WIDTH;
            this._lfps_bar.x = Math.min(1,this._min_fps / stage.frameRate) * _WIDTH;
            this._hfps_bar.x = Math.min(1,this._max_fps / stage.frameRate) * _WIDTH;
         }
         else if(this._updates % 5 == 0)
         {
            this._redrawMemGraph();
         }
         this._mem_graph.x = this._updates % 5;
         ++this._updates;
      }
      
      private function _redrawMemGraph() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Graphics = null;
         var _loc3_:Number = 0;
         this._mem_graph.scaleY = 1;
         _loc2_ = this._mem_graph.graphics;
         _loc2_.clear();
         _loc2_.lineStyle(0.5,_MEM_COL,1,true,LineScaleMode.NONE);
         _loc2_.moveTo(5 * (this._mem_points.length - 1),-this._mem_points[this._mem_points.length - 1]);
         _loc1_ = this._mem_points.length - 1;
         while(_loc1_ >= 0)
         {
            if(this._mem_points[_loc1_ + 1] == 0 || this._mem_points[_loc1_] == 0)
            {
               _loc2_.moveTo(_loc1_ * 5,-this._mem_points[_loc1_]);
            }
            else
            {
               _loc2_.lineTo(_loc1_ * 5,-this._mem_points[_loc1_]);
               if(this._mem_points[_loc1_] > _loc3_)
               {
                  _loc3_ = this._mem_points[_loc1_];
               }
            }
            _loc1_--;
         }
         this._mem_graph.scaleY = this._dia_bmp.height / _loc3_;
      }
      
      private function _getRamString(param1:Number) : String
      {
         var _loc2_:String = "B";
         if(param1 > 1048576)
         {
            param1 /= 1048576;
            _loc2_ = "M";
         }
         else if(param1 > 1024)
         {
            param1 /= 1024;
            _loc2_ = "K";
         }
         return param1.toFixed(1) + _loc2_;
      }
      
      private function _reset() : void
      {
         var _loc1_:int = 0;
         this._updates = 0;
         this._num_frames = 0;
         this._min_fps = int.MAX_VALUE;
         this._max_fps = 0;
         this._avg_fps = 0;
         this._fps_sum = 0;
         this._max_ram = 0;
         _loc1_ = 0;
         while(_loc1_ < _WIDTH / 5)
         {
            this._mem_points[_loc1_] = 0;
            _loc1_++;
         }
         if(this._mean_data)
         {
            _loc1_ = 0;
            while(_loc1_ < this._mean_data.length)
            {
               this._mean_data[_loc1_] = 0;
               _loc1_++;
            }
         }
         this._mem_graph.graphics.clear();
         this._dia_bmp.fillRect(this._dia_bmp.rect,0);
      }
      
      private function _endDrag() : void
      {
         if(this.x < -_WIDTH)
         {
            this.x = -(_WIDTH - 20);
         }
         else if(this.x > stage.stageWidth)
         {
            this.x = stage.stageWidth - 20;
         }
         if(this.y < 0)
         {
            this.y = 0;
         }
         else if(this.y > stage.stageHeight)
         {
            this.y = stage.stageHeight - 15;
         }
         this.x = Math.round(this.x);
         this.y = Math.round(this.y);
         this._dragging = false;
         stage.removeEventListener(Event.MOUSE_LEAVE,this._onMouseUpOrLeave);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this._onMouseUpOrLeave);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this._onMouseMove);
      }
      
      private function _onAddedToStage(param1:Event) : void
      {
         this._timer.start();
         addEventListener(Event.ENTER_FRAME,this._onEnterFrame);
      }
      
      private function _onRemovedFromStage(param1:Event) : void
      {
         this._timer.stop();
         removeEventListener(Event.ENTER_FRAME,this._onTimer);
      }
      
      private function _onTimer(param1:Event) : void
      {
         this._ram = System.totalMemory;
         if(this._ram > this._max_ram)
         {
            this._max_ram = this._ram;
         }
         if(this._updates % 5 == 0)
         {
            this._mem_points.unshift(this._ram / 1024);
            this._mem_points.pop();
         }
         this._redrawStats();
      }
      
      private function _onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = getTimer() - this._last_frame_timestamp;
         this._fps = Math.floor(1000 / _loc2_);
         this._fps_sum += this._fps;
         if(this._fps > this._max_fps)
         {
            this._max_fps = this._fps;
         }
         else if(this._fps != 0 && this._fps < this._min_fps)
         {
            this._min_fps = this._fps;
         }
         if(this._mean_data)
         {
            this._mean_data.push(this._fps);
            this._fps_sum -= Number(this._mean_data.shift());
            this._avg_fps = this._fps_sum / this._mean_data_length;
         }
         else
         {
            ++this._num_frames;
            this._avg_fps = this._fps_sum / this._num_frames;
         }
         this._last_frame_timestamp = getTimer();
      }
      
      private function _onDiagramClick(param1:MouseEvent) : void
      {
         stage.frameRate -= Math.floor((this._diagram.mouseY - this._dia_bmp.height / 2) / 5);
      }
      
      private function _onAverageFpsClick_reset(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(!this._dragging)
         {
            this._num_frames = 0;
            this._fps_sum = 0;
            if(this._mean_data)
            {
               _loc2_ = 0;
               while(_loc2_ < this._mean_data.length)
               {
                  this._mean_data[_loc2_] = 0;
                  _loc2_++;
               }
            }
         }
      }
      
      private function _onCountersClick_reset(param1:MouseEvent) : void
      {
         this._reset();
      }
      
      private function _onMinMaxBtnClick(param1:MouseEvent) : void
      {
         this._minimized = !this._minimized;
         this._redrawWindow();
      }
      
      private function _onTopBarMouseDown(param1:MouseEvent) : void
      {
         this._drag_dx = this.mouseX;
         this._drag_dy = this.mouseY;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this._onMouseMove);
         stage.addEventListener(MouseEvent.MOUSE_UP,this._onMouseUpOrLeave);
         stage.addEventListener(Event.MOUSE_LEAVE,this._onMouseUpOrLeave);
      }
      
      private function _onMouseMove(param1:MouseEvent) : void
      {
         this._dragging = true;
         this.x = stage.mouseX - this._drag_dx;
         this.y = stage.mouseY - this._drag_dy;
      }
      
      private function _onMouseUpOrLeave(param1:Event) : void
      {
         this._endDrag();
      }
   }
}

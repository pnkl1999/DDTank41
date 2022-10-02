package com.pickgliss.effect
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class AddMovieEffect extends BaseEffect implements IEffect
   {
       
      
      private var _movies:Vector.<DisplayObject>;
      
      private var _rectangles:Vector.<Rectangle>;
      
      private var _data:Array;
      
      public function AddMovieEffect(param1:int)
      {
         super(param1);
      }
      
      override public function initEffect(param1:DisplayObject, param2:Array) : void
      {
         super.initEffect(param1,param2);
         this._data = param2;
         this.creatMovie();
      }
      
      public function get movie() : Vector.<DisplayObject>
      {
         return this._movies;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         var _loc1_:int = 0;
         while(_loc1_ < this._movies.length)
         {
            if(this._movies[_loc1_] is MovieClip)
            {
               MovieClip(this._movies[_loc1_]).stop();
            }
            if(this._movies[_loc1_])
            {
               ObjectUtils.disposeObject(this._movies[_loc1_]);
            }
            _loc1_++;
         }
         this._movies = null;
      }
      
      override public function play() : void
      {
         super.play();
         var _loc1_:int = 0;
         while(_loc1_ < this._movies.length)
         {
            if(this._movies[_loc1_] is MovieClip)
            {
               MovieClip(this._movies[_loc1_]).play();
            }
            if(_target.parent)
            {
               _target.parent.addChild(this._movies[_loc1_]);
            }
            this._movies[_loc1_].x = _target.x;
            this._movies[_loc1_].y = _target.y;
            if(this._rectangles.length - 1 >= _loc1_)
            {
               this._movies[_loc1_].x += this._rectangles[_loc1_].x;
               this._movies[_loc1_].y += this._rectangles[_loc1_].y;
            }
            _loc1_++;
         }
      }
      
      override public function stop() : void
      {
         super.stop();
         var _loc1_:int = 0;
         while(_loc1_ < this._movies.length)
         {
            if(this._movies[_loc1_] is MovieClip)
            {
               MovieClip(this._movies[_loc1_]).stop();
            }
            if(this._movies[_loc1_].parent)
            {
               this._movies[_loc1_].parent.removeChild(this._movies[_loc1_]);
            }
            _loc1_++;
         }
      }
      
      private function creatMovie() : void
      {
         this._movies = new Vector.<DisplayObject>();
         this._rectangles = new Vector.<Rectangle>();
         var _loc1_:int = 0;
         while(_loc1_ < this._data.length)
         {
            if(this._data[_loc1_] is DisplayObject)
            {
               this._movies.push(this._data[_loc1_]);
            }
            else if(this._data[_loc1_] is String)
            {
               this._movies.push(ComponentFactory.Instance.creat(this._data[_loc1_]));
            }
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._data.length)
         {
            if(this._data[_loc2_] is Point)
            {
               this._rectangles.push(new Rectangle(this._data[_loc2_].x,this._data[_loc2_].y,0,0));
            }
            else if(this._data[_loc2_] is Rectangle)
            {
               this._rectangles.push(this._data[_loc2_]);
            }
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._movies.length)
         {
            if(this._movies[_loc3_] is InteractiveObject)
            {
               InteractiveObject(this._movies[_loc3_]).mouseEnabled = false;
            }
            if(this._movies[_loc3_] is DisplayObjectContainer)
            {
               DisplayObjectContainer(this._movies[_loc3_]).mouseChildren = false;
               DisplayObjectContainer(this._movies[_loc3_]).mouseEnabled = false;
            }
            _loc3_++;
         }
      }
   }
}

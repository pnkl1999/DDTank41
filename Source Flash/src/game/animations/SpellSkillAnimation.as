package game.animations
{
   import com.pickgliss.utils.ClassUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import game.objects.GamePlayer;
   import game.view.GameViewBase;
   import game.view.map.MapView;
   import road7th.math.interpolateNumber;
   
   public class SpellSkillAnimation extends EventDispatcher implements IAnimate
   {
       
      
      private var _begin:Point;
      
      private var _end:Point;
      
      private var _scale:Number;
      
      private var _life:int;
      
      private var _backlist:Array;
      
      private var _finished:Boolean;
      
      private var _player:GamePlayer;
      
      private var _characterCopy:Bitmap;
      
      private var _gameView:GameViewBase;
      
      private var _skill:Sprite;
      
      private var _skillAsset:MovieClip;
      
      private var _effect:ScaleEffect;
      
      private var _skillType:int;
      
      private var map:MapView;
      
      public function SpellSkillAnimation(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:GamePlayer, param8:GameViewBase)
      {
         super();
         this._scale = 1.5;
         var _loc9_:Number = -param5 * this._scale + param3;
         var _loc10_:Number = -param6 * this._scale + param4;
         var _loc11_:Matrix = new Matrix(this._scale,0,0,this._scale);
         this._end = new Point(param1,param2);
         this._end = _loc11_.transformPoint(this._end);
         this._end.x = param3 / 2 - this._end.x;
         this._end.y = param4 / 4 * 3 - this._end.y;
         this._end.x = this._end.x > 0 ? Number(Number(0)) : (this._end.x < _loc9_ ? Number(Number(_loc9_)) : Number(Number(this._end.x)));
         this._end.y = this._end.y > 0 ? Number(Number(0)) : (this._end.y < _loc10_ ? Number(Number(_loc10_)) : Number(Number(this._end.y)));
         this._player = param7;
         this._gameView = param8;
         this._life = 0;
         this._backlist = new Array();
         this._finished = false;
         this._skillType = Math.ceil(Math.random() * 4);
      }
      
      public function get level() : int
      {
         return AnimationLevel.HIGHT;
      }
      
      public function canAct() : Boolean
      {
         return !this._finished;
      }
      
      public function prepare(param1:AnimationSet) : void
      {
      }
      
      public function canReplace(param1:IAnimate) : Boolean
      {
         return false;
      }
      
      public function cancel() : void
      {
         if(this._skill && this._skill.parent)
         {
            this._skill.parent.removeChild(this._skill);
         }
         if(this._skillAsset && this._skillAsset.parent)
         {
            this._skillAsset.parent.removeChild(this._skillAsset);
         }
         if(this._effect)
         {
            this._effect.dispose();
         }
         if(this.map)
         {
            this.map.restoreStageTopLiving();
            while(this._backlist.length > 0)
            {
               this.map.setMatrx(this._backlist.pop());
            }
            if(this.map.ground)
            {
               this.map.ground.alpha = 1;
            }
            if(this.map.stone)
            {
               this.map.stone.alpha = 1;
            }
            if(this.map.sky)
            {
               this.map.sky.alpha = 1;
            }
            this.map.showPhysical();
         }
         this.map = null;
         this._player = null;
         this._gameView = null;
         this._skill = null;
         this._skillAsset = null;
         this._effect = null;
      }
      
      public function update(param1:MapView) : Boolean
      {
         var a:Number = NaN;
         var tp:Point = null;
         var s:Number = NaN;
         var m:Matrix = null;
         var bmd:BitmapData = null;
         var movie:MapView = param1;
         try
         {
            this.map = movie;
            ++this._life;
            if(this._skill && this._effect)
            {
               this._skill.addChild(this._effect);
            }
            if(this._life == 1)
            {
               this._skillAsset = MovieClip(ClassUtils.CreatInstance("asset.game.RadialAsset"));
               this.map.sky.alpha = 1 - this._life / 20;
               this.map.hidePhysical(this._player);
               this._gameView.addChildAt(this._skillAsset,1);
               this.map.bringToStageTop(this._player);
            }
            else if(this._life < 6)
            {
               if(this._backlist.length == 0)
               {
                  this._begin = new Point(this.map.x,this.map.y);
                  this._backlist.push(this.map.transform.matrix.clone());
               }
               this.map.sky.alpha = 1 - this._life / 15;
               tp = Point.interpolate(this._end,this._begin,(this._life - 1) / 5);
               s = interpolateNumber(0,1,1,this._scale,(this._life - 1) / 5);
               m = new Matrix();
               m.scale(s,s);
               m.translate(tp.x,tp.y);
               this.map.setMatrx(m);
               this._backlist.push(m);
            }
            else if(this._life < 15)
            {
               this.map.sky.alpha = 1 - this._life / 15;
            }
            else if(this._life == 15)
            {
               this.map.sky.alpha = 1 - this._life / 15;
               if(this._skillAsset && this._skillAsset.parent)
               {
                  this._skillAsset.parent.removeChild(this._skillAsset);
               }
               this._skill = this.createSkillCartoon(this._skillType);
               this._skill.mouseChildren = this._skill.mouseEnabled = false;
               bmd = Math.random() > 0.3 ? this._player.character.charaterWithoutWeapon : this._player.character.winCharater;
               this._effect = new ScaleEffect(this._skillType,bmd);
               this._skill.addChild(this._effect);
               this._skill.scaleX = this._player.player.direction;
               this._skill.x = this._player.player.direction > 0 ? Number(Number(0)) : Number(Number(1000));
               this._gameView.addChildAt(this._skill,1);
            }
            else if(this._life == 52)
            {
               this.map.showPhysical();
            }
            else if(this._life > 47)
            {
               if(this._backlist.length > 0)
               {
                  this.map.setMatrx(this._backlist.pop());
                  this.map.sky.alpha = (this._life - 47) / 5;
               }
               else
               {
                  this.cancel();
                  this._finished = true;
                  dispatchEvent(new Event(Event.COMPLETE));
               }
            }
         }
         catch(e:Error)
         {
            cancel();
         }
         return true;
      }
      
      private function createSkillCartoon(param1:int) : Sprite
      {
         var _loc2_:String = "";
         if(param1 == 2)
         {
            _loc2_ = "asset.game.specialSkillA" + Math.ceil(Math.random() * 4);
         }
         else
         {
            _loc2_ = "asset.game.specialSkillB" + Math.ceil(Math.random() * 4);
         }
         return MovieClip(ClassUtils.CreatInstance(_loc2_));
      }
      
      public function get finish() : Boolean
      {
         return this._finished;
      }
   }
}

package fightLib.view
{
   import com.pickgliss.effect.AddMovieEffect;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class LessonButton extends Sprite implements Disposeable
   {
      
      public static const hitCommands:Vector.<int> = Vector.<int>([1,2,2,2,2,2]);
      
      public static const hitCoords:Vector.<Number> = Vector.<Number>([52,1,115,3,117,21,91,94,24,88,20,67]);
      
      public static const SelectedLesson:String = "SelectedLesson";
       
      
      private var _type:int = -1;
      
      private var _enabled:Boolean = true;
      
      private var _background:DisplayObject;
      
      private var _icon:DisplayObject;
      
      private var _label:DisplayObject;
      
      private var _hitShape:Sprite;
      
      private var _lastIcon:DisplayObject;
      
      private var _lastLabel:DisplayObject;
      
      private var _labelString:String;
      
      private var _iconString:String;
      
      private var _shine:Boolean;
      
      private var _selected:Boolean = false;
      
      private var _shineEffect:IEffect;
      
      private var _selectedBitmap:Bitmap;
      
      private var _mesIdx:String;
      
      public function LessonButton()
      {
         super();
         this.configUI();
         this.addEvent();
      }
      
      private static function createShineEffect(param1:LessonButton) : IEffect
      {
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("fightLib.Lessons.LessonShinePosition");
         return EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,param1,"fightLib.Lessons.LessonShine",_loc2_);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._background)
         {
            ObjectUtils.disposeObject(this._background);
            this._background = null;
         }
         if(this._hitShape)
         {
            ObjectUtils.disposeObject(this._hitShape);
            this._hitShape = null;
         }
         if(this._icon)
         {
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
         }
         if(this._label)
         {
            ObjectUtils.disposeObject(this._label);
            this._label = null;
         }
         if(this._lastIcon)
         {
            ObjectUtils.disposeObject(this._lastIcon);
            this._lastIcon = null;
         }
         if(this._selectedBitmap)
         {
            ObjectUtils.disposeObject(this._selectedBitmap);
            this._selectedBitmap = null;
         }
         if(this._shineEffect)
         {
            EffectManager.Instance.removeEffect(this._shineEffect);
            this._shineEffect = null;
         }
      }
      
      public function set mesIdx(param1:String) : void
      {
         this._mesIdx = param1;
      }
      
      public function get mesIdx() : String
      {
         return this._mesIdx;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this._enabled != param1)
         {
            this._enabled = param1;
            if(this._enabled)
            {
               this.setIcon(ComponentFactory.Instance.creatBitmap(this._iconString));
               this.setLabel(ComponentFactory.Instance.creatBitmap(this._labelString));
               filters = null;
            }
            else
            {
               filters = ComponentFactory.Instance.creatFilters("grayFilter");
               if(!this._iconString)
               {
                  this.setIcon(ComponentFactory.Instance.creatBitmap("fightLib.Lessons.icon.Disenable"));
                  this.setLabel(ComponentFactory.Instance.creatBitmap("fightLib.Lessons.label.Disenable"));
               }
               if(this._shine)
               {
                  this.shine = false;
               }
               if(this._selected)
               {
                  this.selected = false;
               }
            }
            this.drawHit();
         }
      }
      
      public function set icon(param1:String) : void
      {
         this._iconString = param1;
         this.setIcon(ComponentFactory.Instance.creatBitmap(param1));
      }
      
      public function get icon() : String
      {
         return this._iconString;
      }
      
      public function set label(param1:String) : void
      {
         this._labelString = param1;
         this.setLabel(ComponentFactory.Instance.creatBitmap(param1));
      }
      
      public function get label() : String
      {
         return this._labelString;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
         this.drawHit();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected != param1)
         {
            this._selected = param1;
            this._selectedBitmap.visible = this._selected;
         }
      }
      
      public function get shine() : Boolean
      {
         return this._shine;
      }
      
      public function set shine(param1:Boolean) : void
      {
         var _loc2_:DisplayObject = null;
         if(this._shine != param1)
         {
            this._shine = param1;
            if(this._shine)
            {
               if(this._enabled)
               {
                  this._shineEffect.play();
               }
            }
            else
            {
               this._shineEffect.stop();
               for each(_loc2_ in AddMovieEffect(this._shineEffect).movie)
               {
                  if(_loc2_ is MovieClip)
                  {
                     MovieClip(_loc2_).gotoAndStop(1);
                  }
               }
            }
         }
      }
      
      public function setIcon(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObject = this._icon;
         this._icon = param1;
         if(this._icon)
         {
            addChildAt(this._icon,0);
         }
         if(_loc2_ && _loc2_ != this._icon)
         {
            ObjectUtils.disposeObject(_loc2_);
         }
      }
      
      public function setLabel(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObject = this._label;
         this._label = param1;
         if(this._label)
         {
            addChild(this._label);
         }
         if(this._icon)
         {
            this._label.x = this._icon.x + this._icon.width - this._label.width;
            this._label.y = this._icon.y + this._icon.height - this._label.height;
         }
         if(_loc2_ && _loc2_ != this._label)
         {
            ObjectUtils.disposeObject(_loc2_);
         }
      }
      
      private function configUI() : void
      {
         this._hitShape = new Sprite();
         this._hitShape.buttonMode = true;
         addChild(this._hitShape);
         this._shineEffect = createShineEffect(this);
         this._selectedBitmap = ComponentFactory.Instance.creatBitmap("fightLib.Lessons.lesson.Selected");
         addChildAt(this._selectedBitmap,0);
         this.drawHit();
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         if(!this._selected && this._type > 0)
         {
            this._selectedBitmap.visible = true;
         }
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         if(this._selectedBitmap.visible && !this._selected)
         {
            this._selectedBitmap.visible = false;
         }
      }
      
      private function addEvent() : void
      {
         this._hitShape.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         this._hitShape.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
         this._hitShape.addEventListener(MouseEvent.CLICK,this.__clicked);
      }
      
      private function removeEvent() : void
      {
         this._hitShape.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         this._hitShape.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
         this._hitShape.removeEventListener(MouseEvent.CLICK,this.__clicked);
      }
      
      private function drawHit() : void
      {
         var _loc1_:Graphics = this._hitShape.graphics;
         _loc1_.clear();
         if(this._type > 0)
         {
            _loc1_.beginFill(16777215 * Math.random(),0);
            _loc1_.drawPath(hitCommands,hitCoords);
            _loc1_.endFill();
         }
      }
      
      private function __clicked(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._enabled)
         {
            dispatchEvent(new Event(SelectedLesson));
         }
         else if(this._mesIdx)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.fightLib.Lesson.Message" + this._mesIdx));
         }
      }
   }
}

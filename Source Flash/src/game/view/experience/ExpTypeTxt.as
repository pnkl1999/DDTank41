package game.view.experience
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class ExpTypeTxt extends Sprite implements Disposeable
   {
      
      public static const FIGHTING_EXP:String = "fightingExp";
      
      public static const ATTATCH_EXP:String = "attatchExp";
      
      public static const EXPLOIT_EXP:String = "exploitExp";
       
      
      private var _grayTxt:Bitmap;
      
      private var _lightTxt:Bitmap;
      
      private var _valueTxt:FilterFrameText;
      
      private var _value:Number;
      
      private var _idx:int;
      
      private var _type:String;
      
      private var _movie:MovieClip;
      
      public function ExpTypeTxt(param1:String, param2:int, param3:Number = 0)
      {
         super();
         this._idx = param2;
         this._type = param1;
         this._value = param3;
         this.init();
      }
      
      protected function init() : void
      {
         var _loc1_:Point = null;
         switch(this._type)
         {
            case FIGHTING_EXP:
               this._grayTxt = ComponentFactory.Instance.creatBitmap("asset.experience.fightExpItemTxt_a" + String(this._idx));
               this._lightTxt = ComponentFactory.Instance.creatBitmap("asset.experience.fightExpItemTxt_b" + String(this._idx));
               this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("experience.expTypeTxt");
               break;
            case ATTATCH_EXP:
               if(this._idx == 7)
               {
                  this._movie = ComponentFactory.Instance.creat("asset.expView.goForPowerMovieAsset");
                  _loc1_ = ComponentFactory.Instance.creatCustomObject("gameOver.goForPowerPosition");
                  this._movie.x = _loc1_.x;
                  this._movie.y = _loc1_.y;
               }
               else if(this._idx == 8)
               {
                  this._grayTxt = ComponentFactory.Instance.creatBitmap("asset.experience.exploitExpItemTxt_a4");
                  this._lightTxt = ComponentFactory.Instance.creatBitmap("asset.experience.attachExpItemTxt_b" + String(this._idx));
               }
               else
               {
                  this._grayTxt = ComponentFactory.Instance.creatBitmap("asset.experience.attachExpItemTxt_a" + String(this._idx));
                  this._lightTxt = ComponentFactory.Instance.creatBitmap("asset.experience.attachExpItemTxt_b" + String(this._idx));
               }
               this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("experience.expTypeTxt");
               break;
            case EXPLOIT_EXP:
               this._grayTxt = ComponentFactory.Instance.creatBitmap("asset.experience.exploitExpItemTxt_a" + String(this._idx));
               this._lightTxt = ComponentFactory.Instance.creatBitmap("asset.experience.exploitExpItemTxt_b" + String(this._idx));
               this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("experience.exploitTypeTxt");
         }
         if(this._valueTxt)
         {
            this._valueTxt.alpha = 0;
         }
         if(this._grayTxt)
         {
            addChild(this._grayTxt);
         }
         if(Boolean(this.value))
         {
            ExpTweenManager.Instance.appendTween(TweenLite.to(this._valueTxt,0.15,{
               "y":"-30",
               "alpha":1,
               "onStart":this.play
            }));
            ExpTweenManager.Instance.appendTween(TweenLite.to(this._valueTxt,0.3,{
               "y":"-20",
               "alpha":0,
               "delay":0.1
            }));
         }
      }
      
      public function play() : void
      {
         SoundManager.instance.play("142");
         if(this._type == ATTATCH_EXP && this._idx == 7)
         {
            this._valueTxt.visible = false;
            if(this._movie)
            {
               addChild(this._movie);
               this._movie.play();
            }
         }
         else
         {
            addChild(this._lightTxt);
            addChild(this._valueTxt);
            this._grayTxt.parent.removeChild(this._grayTxt);
            if(this.value < 0)
            {
               this._valueTxt.text = String(this.value) + "  ";
            }
            else
            {
               this._valueTxt.text = "+" + String(this.value) + "  ";
            }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._lightTxt);
         ObjectUtils.disposeObject(this._valueTxt);
         this._lightTxt = null;
         this._valueTxt = null;
         if(this._grayTxt)
         {
            ObjectUtils.disposeObject(this._grayTxt);
            this._grayTxt = null;
         }
         ObjectUtils.disposeObject(this._movie);
         this._movie = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

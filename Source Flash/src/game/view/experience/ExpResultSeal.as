package game.view.experience
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class ExpResultSeal extends Sprite implements Disposeable
   {
      
      public static const WIN:String = "win";
      
      public static const LOSE:String = "lose";
       
      
      private var _luckyShapes:Vector.<DisplayObject>;
      
      private var _luckyExp:Boolean;
      
      private var _luckyOffer:Boolean;
      
      private var _bitmap:Bitmap;
      
      private var _starMc:MovieClip;
      
      private var _effectMc:MovieClip;
      
      private var _result:String;
      
      public function ExpResultSeal(param1:String = "lose", param2:Boolean = false, param3:Boolean = false)
      {
         this._luckyShapes = new Vector.<DisplayObject>();
         super();
         this._result = param1;
         this._luckyExp = param2;
         this._luckyOffer = param3;
         this.init();
      }
      
      protected function init() : void
      {
         PositionUtils.setPos(this,"experience.ResultSealPos");
         if(this._result == WIN)
         {
            this._bitmap = ComponentFactory.Instance.creatBitmap("asset.experience.rightViewWin");
            this._starMc = ComponentFactory.Instance.creat("experience.WinStar");
            this._effectMc = ComponentFactory.Instance.creat("experience.WinEffectLight");
            addChild(this._starMc);
            addChildAt(this._effectMc,0);
         }
         else
         {
            this._bitmap = ComponentFactory.Instance.creatBitmap("asset.experience.rightViewLose");
         }
         addChild(this._bitmap);
         if(this._luckyExp)
         {
            this._luckyShapes.push(ComponentFactory.Instance.creat("asset.expView.LuckyExp"));
         }
         if(this._luckyOffer)
         {
            this._luckyShapes.push(ComponentFactory.Instance.creat("asset.expView.LuckyOffer"));
         }
         var _loc1_:Point = ComponentFactory.Instance.creat("experience.ResultSealLuckyLeft");
         var _loc2_:int = 0;
         while(_loc2_ < this._luckyShapes.length)
         {
            this._luckyShapes[_loc2_].x = _loc1_.x + _loc2_ * 124;
            addChild(this._luckyShapes[_loc2_]);
            _loc2_++;
         }
      }
      
      public function dispose() : void
      {
         if(this._starMc && this._starMc.parent)
         {
            this._starMc.parent.removeChild(this._starMc);
         }
         if(this._effectMc && this._effectMc.parent)
         {
            this._effectMc.parent.removeChild(this._effectMc);
         }
         this._starMc = null;
         this._effectMc = null;
         if(this._bitmap)
         {
            ObjectUtils.disposeObject(this._bitmap);
            this._bitmap = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         var _loc1_:DisplayObject = this._luckyShapes.shift();
         while(_loc1_ != null)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = this._luckyShapes.shift();
         }
      }
   }
}

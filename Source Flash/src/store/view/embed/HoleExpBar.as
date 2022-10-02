package store.view.embed
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.TransformableComponent;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   
   public class HoleExpBar extends TransformableComponent
   {
      
      private static const P_Rate:String = "p_rate";
       
      
      private var thickness:int = 3;
      
      private var _rate:Number = 0;
      
      private var _back:BitmapData;
      
      private var _thumb:BitmapData;
      
      private var _rateField:FilterFrameText;
      
      public function HoleExpBar()
      {
         super();
         this.configUI();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatBitmapData("asset.store.embed.HoleExpBack");
         this._thumb = ComponentFactory.Instance.creatBitmapData("asset.store.embed.HoleExpThumb");
         this._rateField = ComponentFactory.Instance.creatComponentByStylename("store.embed.ExpRateField");
         addChild(this._rateField);
         _width = this._back.width;
         _height = this._back.height;
         this.draw();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
      }
      
      override public function draw() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Matrix = null;
         super.draw();
         var _loc1_:Graphics = graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(this._back);
         _loc1_.drawRect(0,0,_width,_height);
         _loc1_.endFill();
         if(_width > this.thickness * 3 && _height > this.thickness * 3 && this._rate > 0)
         {
            _loc2_ = _width - this.thickness * 2;
            _loc3_ = new Matrix();
            _loc3_.translate(this.thickness,this.thickness);
            _loc1_.beginBitmapFill(this._thumb,_loc3_);
            _loc1_.drawRect(this.thickness,this.thickness,_loc2_ * this._rate,_height - this.thickness * 2);
            _loc1_.endFill();
         }
         this._rateField.text = int(this._rate * 100) + "%";
      }
      
      public function setProgress(param1:int, param2:int = 100) : void
      {
         this._rate = param1 / param2;
         this._rate = this._rate > 1 ? Number(Number(1)) : Number(Number(this._rate));
         onPropertiesChanged(P_Rate);
      }
      
      override public function dispose() : void
      {
         if(this._back)
         {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
         }
         if(this._thumb)
         {
            ObjectUtils.disposeObject(this._thumb);
            this._thumb = null;
         }
         if(this._rateField)
         {
            ObjectUtils.disposeObject(this._rateField);
         }
         this._rateField = null;
         super.dispose();
      }
   }
}

package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class StarBar extends Sprite implements Disposeable
   {
      
      public static var SPACE:int = 0.2;
      
      public static var TOTAL_STAR:int = 5;
       
      
      private var _starImgVec:Vector.<Bitmap>;
      
      public function StarBar()
      {
         super();
         this._starImgVec = new Vector.<Bitmap>();
      }
      
      public function starNum(param1:int, param2:String = "assets.petsBag.star") : void
      {
         var _loc3_:Bitmap = null;
         if(param1 > 0)
         {
            if(param1 > TOTAL_STAR)
            {
               param1 = TOTAL_STAR;
            }
            this.remove();
            while(param1--)
            {
               _loc3_ = ComponentFactory.Instance.creatBitmap(param2);
               this._starImgVec.push(_loc3_);
            }
            this.update();
         }
         else
         {
            this.remove();
         }
      }
      
      private function update() : void
      {
         var _loc1_:int = this._starImgVec.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            addChild(this._starImgVec[_loc2_]);
            this._starImgVec[_loc2_].x = _loc2_ * (this._starImgVec[_loc2_].width - 3) + SPACE;
            _loc2_++;
         }
      }
      
      private function remove() : void
      {
         var _loc1_:int = this._starImgVec.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            ObjectUtils.disposeObject(this._starImgVec[_loc2_]);
            _loc2_++;
         }
         this._starImgVec.splice(0,this._starImgVec.length);
      }
      
      public function dispose() : void
      {
         this.remove();
         this._starImgVec = null;
      }
   }
}

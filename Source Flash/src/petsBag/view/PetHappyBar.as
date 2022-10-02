package petsBag.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import pet.date.PetInfo;
   
   public class PetHappyBar extends Component implements Disposeable
   {
      
      public static const petPercentArray:Array = ["0%","60%","80%","100%"];
      
      public static const fullHappyValue:int = 10000;
       
      
      private var SPACE:int = 2;
      
      private var COUNT:int = 3;
      
      private var _heartImgVec:Vector.<Bitmap>;
      
      private var _info:PetInfo;
      
      private var _lvTxt:FilterFrameText;
      
      public function PetHappyBar()
      {
         super();
         this._heartImgVec = new Vector.<Bitmap>();
         this.initView();
      }
      
      public function get info() : PetInfo
      {
         return this._info;
      }
      
      public function set info(param1:PetInfo) : void
      {
         this._info = param1;
         this.tipData = this._info;
         this.happyStatus = !!Boolean(this._info) ? int(int(this._info.PetHappyStar)) : int(int(0));
         this._lvTxt.text = !!Boolean(this._info) ? this._info.Level.toString() : "";
      }
      
      private function gapWidth() : Number
      {
         return this._lvTxt.x + 28;
      }
      
      private function initView() : void
      {
         this._lvTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.Lv");
         addChild(this._lvTxt);
      }
      
      private function set happyStatus(param1:int) : void
      {
         if(param1 > 0)
         {
            if(param1 > this.COUNT)
            {
               param1 = this.COUNT;
            }
            this.update(param1);
         }
         else
         {
            this.remove();
         }
      }
      
      private function update(param1:int) : void
      {
         var _loc3_:Bitmap = null;
         this.remove();
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            _loc3_ = ComponentFactory.Instance.creatBitmap("assets.petsBag.heart2");
            this._heartImgVec.push(_loc3_);
            addChild(_loc3_);
            if(_loc2_ == 0)
            {
               _loc3_.x = this.gapWidth() + 2 + _loc2_ * _loc3_.width + this.SPACE;
            }
            else if(_loc2_ == 1)
            {
               _loc3_.x = this.gapWidth() + 5 + _loc2_ * _loc3_.width + this.SPACE;
            }
            else if(_loc2_ == 2)
            {
               _loc3_.x = this.gapWidth() + 8 + _loc2_ * _loc3_.width + this.SPACE;
            }
            _loc2_++;
         }
      }
      
      private function remove() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = this._heartImgVec.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            ObjectUtils.disposeObject(this._heartImgVec[_loc1_]);
            _loc1_++;
         }
         this._heartImgVec.splice(0,this._heartImgVec.length);
      }
      
      override public function dispose() : void
      {
         this.remove();
         this._heartImgVec = null;
         if(this._lvTxt)
         {
            ObjectUtils.disposeObject(this._lvTxt);
            this._lvTxt = null;
         }
         super.dispose();
      }
   }
}

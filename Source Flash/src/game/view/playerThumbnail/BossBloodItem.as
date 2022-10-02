package game.view.playerThumbnail
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class BossBloodItem extends Sprite implements Disposeable
   {
       
      
      private var _totalBlood:int;
      
      private var _bloodNum:int;
      
      private var _maskShape:Shape;
      
      private var _HPTxt:FilterFrameText;
      
      private var _bg:Bitmap;
      
      private var _rateTxt:FilterFrameText;
      
      public function BossBloodItem(param1:int)
      {
         super();
         this._totalBlood = param1;
         this._bloodNum = param1;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.bossHpStripAsset");
         addChild(this._bg);
         this._maskShape = new Shape();
         this._maskShape.x = 13;
         this._maskShape.y = 7;
         this._maskShape.graphics.beginFill(0,1);
         this._maskShape.graphics.drawRect(0,0,120,25);
         this._maskShape.graphics.endFill();
         this._bg.mask = this._maskShape;
         addChild(this._maskShape);
         this._rateTxt = ComponentFactory.Instance.creatComponentByStylename("asset.bossHPStripRateTxt");
         addChild(this._rateTxt);
         this._rateTxt.text = "100%";
      }
      
      public function set bloodNum(param1:int) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > this._totalBlood)
         {
            param1 = this._totalBlood;
         }
         this._bloodNum = param1;
         this.updateView();
      }
	  
	  public function updateBlood(param1:Number, param2:Number) : void
	  {
		  this._bloodNum = param1;
		  if(this._bloodNum < 0)
		  {
			  this._bloodNum = 0;
		  }
		  this._totalBlood = param2;
		  if(this._totalBlood < this._bloodNum)
		  {
			  this._totalBlood = this._bloodNum;
		  }
		  this.updateView();
	  }
      
      private function updateView() : void
      {
         var _loc1_:int = this.getRate(this._bloodNum,this._totalBlood);
         this._rateTxt.text = _loc1_.toString() + "%" + " ~ " + this._bloodNum;
         this._maskShape.width = 120 * (_loc1_ / 100);
         this._bg.mask = this._maskShape;
      }
      
      private function getRate(param1:int, param2:int) : int
      {
         var _loc3_:Number = param1 / param2 * 100;
         if(_loc3_ > 0 && _loc3_ < 1)
         {
            _loc3_ = 1;
         }
         return int(_loc3_);
      }
      
      public function dispose() : void
      {
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         removeChild(this._maskShape);
         this._maskShape = null;
         if(this._HPTxt)
         {
            this._HPTxt.dispose();
            this._HPTxt = null;
         }
         ObjectUtils.disposeObject(this._rateTxt);
         this._rateTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

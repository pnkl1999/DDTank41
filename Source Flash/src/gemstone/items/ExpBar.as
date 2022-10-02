package gemstone.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ExpBar extends Sprite implements Disposeable
   {
       
      
      protected var _groudPic:Bitmap;
      
      protected var _curPic:Bitmap;
      
      protected var _curPicContent:Sprite;
      
      private var _totalLen:int;
      
      protected var _expBarTxt:FilterFrameText;
      
      protected var _maskMC:Sprite;
      
      private var _per:Number = 0;
      
      public var curNum:int = 0;
      
      public var totalNum:int = 0;
      
      public var id:int;
      
      public var stylename:String;
      
      protected var _oldX:int;
      
      public function ExpBar()
      {
         super();
         this.initView();
      }
      
      public function initView() : void
      {
         this._groudPic = ComponentFactory.Instance.creatBitmap("gemstone.expBack");
         addChild(this._groudPic);
         this._curPic = ComponentFactory.Instance.creatBitmap("gemstone.expFrome");
         addChild(this._curPic);
         this._expBarTxt = ComponentFactory.Instance.creatComponentByStylename("expBarTxt");
         this._expBarTxt.text = "0";
         addChild(this._expBarTxt);
         this._maskMC = new Sprite();
         this._maskMC.graphics.beginFill(0);
         this._maskMC.graphics.drawRect(5,1,196,this._groudPic.height);
         this._maskMC.graphics.endFill();
         addChild(this._maskMC);
         this._maskMC.alpha = 0.2;
         this._curPic.mask = this._maskMC;
         this._oldX = this._curPic.x;
      }
      
      public function beginChanges() : void
      {
      }
      
      public function commitChanges() : void
      {
      }
      
      public function initBar(param1:int, param2:int, param3:Boolean = false) : void
      {
         if(param3)
         {
            this._curPic.x = this._oldX;
            this._expBarTxt.text = "0" + "/" + "0";
            return;
         }
         if(param1 == 0)
         {
            this._curPic.x = this._oldX;
            this._expBarTxt.text = String(param1) + "/" + param2;
            return;
         }
         if(this._curPic.x != this._oldX)
         {
            this._curPic.x = this._oldX;
         }
         this._expBarTxt.text = String(param1) + "/" + param2;
         this.curNum = param1;
         this.totalNum = param2;
         this._per = this.curNum / this.totalNum;
         this._curPic.x = this._curPic.x + this._per * (this._groudPic.width - 10);
      }
      
      public function upData(param1:int) : void
      {
         this.curNum = this.curNum + param1;
         this._per = Number(this.curNum / this.totalNum);
         this._expBarTxt.text = String(this.curNum);
         this._curPic.x = this._curPic.x + this._per * (this._curPic.width - 80);
      }
      
      public function dispose() : void
      {
         while(numChildren)
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

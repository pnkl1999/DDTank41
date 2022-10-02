package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   
   public class TotemRightViewIconTxtDragonBoatCell extends Sprite implements Disposeable
   {
       
      
      private var _txt:FilterFrameText;
      
      private var _iconDiscount:Bitmap;
      
      public function TotemRightViewIconTxtDragonBoatCell()
      {
         super();
         this._txt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.iconCell.txt");
         this._iconDiscount = ComponentFactory.Instance.creatBitmap("totem.rightView.iconDiscount");
         this._iconDiscount.y = -10;
         addChild(this._txt);
         addChild(this._iconDiscount);
      }
      
      public function refresh(param1:int, param2:Boolean = false) : void
      {
         this._txt.text = param1.toString();
         if(param2)
         {
            this._txt.setTextFormat(new TextFormat(null,null,16711680));
         }
         this._iconDiscount.x = this._txt.x + this._txt.textWidth + 5;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._iconDiscount = null;
         this._txt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

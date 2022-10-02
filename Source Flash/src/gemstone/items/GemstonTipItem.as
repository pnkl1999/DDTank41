package gemstone.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import gemstone.GemstoneManager;
   
   public class GemstonTipItem extends Sprite
   {
       
      
      private var txt:FilterFrameText;
      
      private var bitMap:Bitmap;
      
      public function GemstonTipItem()
      {
         super();
      }
      
      public function setInfo(param1:Object) : void
      {
         if(this.bitMap)
         {
            ObjectUtils.disposeObject(this.bitMap);
         }
         if(this.txt)
         {
            ObjectUtils.disposeObject(this.txt);
         }
         switch(param1.id)
         {
            case GemstoneManager.ID1:
               this.txt = ComponentFactory.Instance.creatComponentByStylename("gemstone.redTxt");
               this.bitMap = ComponentFactory.Instance.creatBitmap("gemstone.redIcon");
               break;
            case GemstoneManager.ID2:
               this.txt = ComponentFactory.Instance.creatComponentByStylename("gemstone.bluTxt");
               this.bitMap = ComponentFactory.Instance.creatBitmap("gemstone.bulIcon");
               break;
            case GemstoneManager.ID3:
               this.txt = ComponentFactory.Instance.creatComponentByStylename("gemstone.greTxt");
               this.bitMap = ComponentFactory.Instance.creatBitmap("gemstone.greIcon");
               break;
            case GemstoneManager.ID4:
               this.txt = ComponentFactory.Instance.creatComponentByStylename("gemstone.yelTxt");
               this.bitMap = ComponentFactory.Instance.creatBitmap("gemstone.yelIcon");
               break;
            case GemstoneManager.ID5:
               this.txt = ComponentFactory.Instance.creatComponentByStylename("gemstone.purpleTxt");
               this.bitMap = ComponentFactory.Instance.creatBitmap("gemstone.purpleIcon");
         }
         addChild(this.txt);
         addChild(this.bitMap);
         this.txt.x = this.bitMap.width + 10;
         this.txt.y = this.txt.y + 4;
         this.txt.text = param1.str;
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

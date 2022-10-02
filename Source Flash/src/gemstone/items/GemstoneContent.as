package gemstone.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import gemstone.GemstoneManager;
   import gemstone.info.GemstListInfo;
   import gemstone.info.GemstoneTipVO;
   
   public class GemstoneContent extends Component
   {
      
      public static var _radius:int = 100;
       
      
      public var angle:int;
      
      public var curExp:int;
      
      public var curTotalExp:int;
      
      public var level:int;
      
      public var info:GemstListInfo;
      
      private var _setupAngle:int = 120;
      
      private var _initAngle:int = 30;
      
      private var _bg:MovieClip;
      
      private var _content:Bitmap;
      
      private var _upGradeMc:MovieClip;
      
      private var txt:FilterFrameText;
      
      public function GemstoneContent(param1:int, param2:Point)
      {
         super();
         x = Math.round(param2.x + Math.cos((this._setupAngle * param1 + this._initAngle) / 180 * Math.PI) * _radius);
         y = Math.round(param2.y - Math.sin((this._setupAngle * param1 + this._initAngle) / 180 * Math.PI) * _radius);
         this.angle = this._setupAngle * param1 + this._initAngle;
         this._bg = ComponentFactory.Instance.creat("gemstone.stoneContent");
         addChild(this._bg);
         this._bg.x = -this._bg.width / 2;
         this._bg.y = -this._bg.height / 2;
         this.txt = ComponentFactory.Instance.creatComponentByStylename("gemstoneTxt");
         this.txt.x = -61;
         this.txt.y = -21;
         tipStyle = "gemstone.items.GemstoneLeftViewTip";
         tipDirctions = "2,7";
      }
      
      public function loadSikn(param1:String) : void
      {
         if(this._content)
         {
            ObjectUtils.disposeObject(this._content);
            this._content = null;
         }
         this._content = ComponentFactory.Instance.creatBitmap(param1);
         this._content.smoothing = true;
         this._content.x = -78;
         this._content.y = -79;
         this._content.scaleX = this._content.scaleY = 0.8;
         addChild(this._content);
         addChild(this.txt);
      }
      
      public function upDataLevel() : void
      {
         this.txt.text = "LV" + this.info.level;
         this.updataTip();
      }
      
      public function updataTip() : void
      {
         var _loc1_:GemstoneTipVO = new GemstoneTipVO();
         _loc1_.level = this.info.level;
         var _loc2_:int = this.info.level < GemstoneManager.Instance.curMaxLevel?int(this.info.level + 1):int(0);
         switch(this.info.fightSpiritId)
         {
            case 100001:
               _loc1_.gemstoneType = 1;
               _loc1_.increase = GemstoneManager.Instance.redInfoList[this.info.level].attack;
               _loc1_.nextIncrease = GemstoneManager.Instance.redInfoList[_loc2_].attack;
               break;
            case 100002:
               _loc1_.gemstoneType = 2;
               _loc1_.increase = GemstoneManager.Instance.bluInfoList[this.info.level].defence;
               _loc1_.nextIncrease = GemstoneManager.Instance.bluInfoList[_loc2_].defence;
               break;
            case 100003:
               _loc1_.gemstoneType = 3;
               _loc1_.increase = GemstoneManager.Instance.greInfoList[this.info.level].agility;
               _loc1_.nextIncrease = GemstoneManager.Instance.greInfoList[_loc2_].agility;
               break;
            case 100004:
               _loc1_.gemstoneType = 4;
               _loc1_.increase = GemstoneManager.Instance.yelInfoList[this.info.level].luck;
               _loc1_.nextIncrease = GemstoneManager.Instance.yelInfoList[_loc2_].luck;
               break;
            case 100005:
               _loc1_.gemstoneType = 5;
               _loc1_.increase = GemstoneManager.Instance.purpleInfoList[this.info.level].blood;
               _loc1_.nextIncrease = GemstoneManager.Instance.purpleInfoList[_loc2_].blood;
         }
         tipData = _loc1_;
      }
      
      public function selAlphe(param1:Number) : void
      {
         this._content.alpha = param1;
      }
      
      override public function dispose() : void
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

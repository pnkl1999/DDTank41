package game.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class MissionOverInfoPanel extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      public var titleTxt1:FilterFrameText;
      
      public var titleTxt2:FilterFrameText;
      
      public var titleTxt3:FilterFrameText;
      
      public var valueTxt1:FilterFrameText;
      
      public var valueTxt2:FilterFrameText;
      
      public var valueTxt3:FilterFrameText;
      
      public function MissionOverInfoPanel()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.missionOverInfoPanelAsset");
         addChild(this._bg);
         this.titleTxt1 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionOverInfoTitle1Txt");
         addChild(this.titleTxt1);
         this.titleTxt2 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionOverInfoTitle2Txt");
         addChild(this.titleTxt2);
         this.titleTxt3 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionOverInfoTitle3Txt");
         addChild(this.titleTxt3);
         this.valueTxt1 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionOverInfo1Txt");
         addChild(this.valueTxt1);
         this.valueTxt2 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionOverInfo2Txt");
         addChild(this.valueTxt2);
         this.valueTxt3 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionOverInfo3Txt");
         addChild(this.valueTxt3);
      }
      
      public function dispose() : void
      {
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         this.titleTxt1.dispose();
         this.titleTxt1 = null;
         this.titleTxt2.dispose();
         this.titleTxt2 = null;
         this.titleTxt3.dispose();
         this.titleTxt3 = null;
         this.valueTxt1.dispose();
         this.valueTxt1 = null;
         this.valueTxt2.dispose();
         this.valueTxt2 = null;
         this.valueTxt3.dispose();
         this.valueTxt3 = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

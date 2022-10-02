package gemstone.views
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import gemstone.GemstoneManager;
   import gemstone.info.GemstoneInfo;
   import gemstone.info.GemstoneStaticInfo;
   import gemstone.items.FigSoulItem;
   import gemstone.items.Item;
   
   public class GemstoneInfoView extends Frame
   {
       
      
      private var _stoneItemList:Vector.<Item>;
      
      private var _kind:FilterFrameText;
      
      private var _effect:FilterFrameText;
      
      private var _titleBg1:Bitmap;
      
      private var _titleBg2:Bitmap;
      
      private var _effDesc:FilterFrameText;
      
      private var _zhanhunList:VBox;
      
      private var _loader:BaseLoader;
      
      private var _gInfoList:Vector.<GemstoneStaticInfo>;
      
      private var _item1:FigSoulItem;
      
      private var _item2:FigSoulItem;
      
      private var _item3:FigSoulItem;
      
      private var _item4:FigSoulItem;
      
      private var _item5:FigSoulItem;
      
      private var _redUrl:String;
      
      private var _bulUrl:String;
      
      private var _greUrl:String;
      
      private var _yelUrl:String;
      
      private var _bg:Bitmap;
      
      private var _othersTxt:FilterFrameText;
      
      private var _road:FilterFrameText;
      
      private var _line:Bitmap;
      
      public function GemstoneInfoView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("gemstone.rigth.view");
         addChild(this._bg);
         this._kind = ComponentFactory.Instance.creatComponentByStylename("zhanhunKind");
         this._kind.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gemstoneKind");
         addChild(this._kind);
         this._effect = ComponentFactory.Instance.creatComponentByStylename("zhanhunUseded");
         this._effect.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gemstoneEffect");
         addChild(this._effect);
         this._othersTxt = ComponentFactory.Instance.creatComponentByStylename("othersTxt");
         this._othersTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.othersTxt");
         addChild(this._othersTxt);
         this._road = ComponentFactory.Instance.creatComponentByStylename("zhanhunshuoming");
         this._road.x = 9;
         this._road.y = 390;
         this._road.text = LanguageMgr.GetTranslation("ddt.gemstone.obtain.road");
         addChild(this._road);
         this._zhanhunList = new VBox();
         this._zhanhunList.spacing = 5;
         this._zhanhunList.x = -5;
         this._zhanhunList.y = 46;
         addChild(this._zhanhunList);
         this._item1 = new FigSoulItem("gemstone.attck",LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstone"));
         this._item1.x = 25;
         this._item1.y = 40;
         this._item1.tipData = GemstoneManager.Instance.redInfoList;
         this._item1.height = 40;
         this._zhanhunList.addChild(this._item1);
         this._item2 = new FigSoulItem("gemstone.defense",LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstone"));
         this._item2.x = 25;
         this._item2.y = 90;
         this._item2.tipData = GemstoneManager.Instance.bluInfoList;
         this._item2.height = 40;
         this._zhanhunList.addChild(this._item2);
         this._item3 = new FigSoulItem("gemstone.agile",LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gesGemstone"));
         this._item3.x = 25;
         this._item3.y = 140;
         this._item3.tipData = GemstoneManager.Instance.greInfoList;
         this._item3.height = 40;
         this._zhanhunList.addChild(this._item3);
         this._item4 = new FigSoulItem("gemstone.lucky",LanguageMgr.GetTranslation("ddt.gemstone.curInfo.yelGemstone"));
         this._item4.x = 25;
         this._item4.y = 190;
         this._item4.tipData = GemstoneManager.Instance.yelInfoList;
         this._item4.height = 40;
         this._zhanhunList.addChild(this._item4);
         this._item5 = new FigSoulItem("gemstone.hp",LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstone"));
         this._item5.x = 25;
         this._item5.y = 190;
         this._item5.tipData = GemstoneManager.Instance.purpleInfoList;
         this._item5.height = 40;
         this._zhanhunList.addChild(this._item5);
         this._zhanhunList.arrange();
         this._line = ComponentFactory.Instance.creatBitmap("gemstone.line");
         addChild(this._line);
         this._effDesc = ComponentFactory.Instance.creatComponentByStylename("zhanhunshuoming");
         this._effDesc.text = LanguageMgr.GetTranslation("ddt.gemstone.obtain.effDescri");
         addChild(this._effDesc);
      }
      
      public function initGemstone(param1:Vector.<GemstoneInfo>) : void
      {
      }
      
      override public function dispose() : void
      {
         if(this._titleBg1)
         {
            ObjectUtils.disposeObject(this._titleBg1);
         }
         this._titleBg1 = null;
         if(this._titleBg2)
         {
            ObjectUtils.disposeObject(this._titleBg2);
         }
         this._titleBg2 = null;
         if(this._kind)
         {
            ObjectUtils.disposeObject(this._kind);
         }
         this._kind = null;
         if(this._effect)
         {
            ObjectUtils.disposeObject(this._effect);
         }
         this._effect = null;
         if(this._item1)
         {
            ObjectUtils.disposeObject(this._item1);
         }
         this._item1 = null;
         if(this._item2)
         {
            ObjectUtils.disposeObject(this._item2);
         }
         this._item2 = null;
         if(this._item3)
         {
            ObjectUtils.disposeObject(this._item3);
         }
         this._item3 = null;
         if(this._item4)
         {
            ObjectUtils.disposeObject(this._item4);
         }
         this._item4 = null;
         if(this._item5)
         {
            ObjectUtils.disposeObject(this._item5);
         }
         this._item5 = null;
         if(this._zhanhunList)
         {
            ObjectUtils.disposeObject(this._zhanhunList);
         }
         this._zhanhunList = null;
      }
   }
}

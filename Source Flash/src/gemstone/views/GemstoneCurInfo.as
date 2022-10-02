package gemstone.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class GemstoneCurInfo extends Sprite implements Disposeable
   {
       
      
      private var _title1:Bitmap;
      
      private var _title2:Bitmap;
      
      private var _titleTxt1:FilterFrameText;
      
      private var _titleTxt2:FilterFrameText;
      
      private var _descriptTxt:FilterFrameText;
      
      private var _pdescriptTxt:FilterFrameText;
      
      private var _pZbdescriptTxt:FilterFrameText;
      
      private var _pZbZhidescriptTxt:FilterFrameText;
      
      private var _pZbdescriptTxt1:FilterFrameText;
      
      private var _pZbZhidescriptTxt1:FilterFrameText;
      
      private var _pdescriptTxt1:FilterFrameText;
      
      private var _pdescriptTxt2:FilterFrameText;
      
      private var _pdescriptTxt3:FilterFrameText;
      
      public function GemstoneCurInfo()
      {
         super();
         this._title1 = ComponentFactory.Instance.creatBitmap("gemstone.tiao");
         this._title1.y = 137;
         addChild(this._title1);
         this._title2 = ComponentFactory.Instance.creatBitmap("gemstone.tiao");
         this._title2.y = 292;
         addChild(this._title2);
         this._titleTxt1 = ComponentFactory.Instance.creatComponentByStylename("curZhanhun");
         this._titleTxt1.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.title1");
         this._titleTxt1.y = 144;
         addChild(this._titleTxt1);
         this._titleTxt2 = ComponentFactory.Instance.creatComponentByStylename("curZhanhunzb");
         this._titleTxt2.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.title2");
         this._titleTxt2.y = 299;
         addChild(this._titleTxt2);
         this._descriptTxt = ComponentFactory.Instance.creatComponentByStylename("descriptTxt");
         this._descriptTxt.width = 160;
         this._descriptTxt.x = 10;
         this._descriptTxt.y = 7;
         this._descriptTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.descriptTxt");
         addChild(this._descriptTxt);
         this._pdescriptTxt1 = ComponentFactory.Instance.creatComponentByStylename("pdescriptTxt");
         this._pdescriptTxt1.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt1");
         this._pdescriptTxt1.x = 12;
         this._pdescriptTxt1.y = 178;
         addChild(this._pdescriptTxt1);
         this._pdescriptTxt3 = ComponentFactory.Instance.creatComponentByStylename("pdescriptTxt");
         this._pdescriptTxt3.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt3");
         this._pdescriptTxt3.x = 12;
         this._pdescriptTxt3.y = 200;
         addChild(this._pdescriptTxt3);
         this._pZbdescriptTxt = ComponentFactory.Instance.creatComponentByStylename("pZbdescriptTxt");
         this._pZbdescriptTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pZbdescriptTxt");
         this._pZbdescriptTxt.x = 10;
         this._pZbdescriptTxt.y = 330;
         addChild(this._pZbdescriptTxt);
         this._pZbdescriptTxt1 = ComponentFactory.Instance.creatComponentByStylename("pZbdescriptTxt");
         this._pZbdescriptTxt1.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pZbdescriptTxt1");
         this._pZbdescriptTxt1.x = 10;
         this._pZbdescriptTxt1.y = 360;
         addChild(this._pZbdescriptTxt1);
         this._pZbZhidescriptTxt1 = ComponentFactory.Instance.creatComponentByStylename("pZbZhidescriptTxt");
         this._pZbZhidescriptTxt1.x = 103;
         this._pZbZhidescriptTxt1.y = 331;
         addChild(this._pZbZhidescriptTxt1);
         this._pZbZhidescriptTxt = ComponentFactory.Instance.creatComponentByStylename("pZbZhidescriptTxt");
         this._pZbZhidescriptTxt.x = 103;
         this._pZbZhidescriptTxt.y = 360;
         addChild(this._pZbZhidescriptTxt);
      }
      
      public function update(param1:Object) : void
      {
         if(!param1)
         {
            this._pdescriptTxt1.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt1");
            this._pdescriptTxt3.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.pdescriptTxt3");
            this._pZbZhidescriptTxt1.text = String(0);
            this._pZbZhidescriptTxt.text = String(0);
            return;
         }
         this._pdescriptTxt1.text = String(param1.curLve);
         this._pdescriptTxt3.text = String(param1.upGrdPro);
         this._pZbZhidescriptTxt1.text = String(param1.levHe);
         this._pZbZhidescriptTxt.text = String(param1.proHe);
      }
      
      public function dispose() : void
      {
         if(this._title1)
         {
            ObjectUtils.disposeObject(this._title1);
         }
         this._title1 = null;
         if(this._title2)
         {
            ObjectUtils.disposeObject(this._title2);
         }
         this._title2 = null;
         if(this._titleTxt1)
         {
            ObjectUtils.disposeObject(this._titleTxt1);
         }
         this._titleTxt1 = null;
         if(this._titleTxt2)
         {
            ObjectUtils.disposeObject(this._titleTxt2);
         }
         this._titleTxt2 = null;
         if(this._descriptTxt)
         {
            ObjectUtils.disposeObject(this._descriptTxt);
         }
         this._descriptTxt = null;
         if(this._pdescriptTxt1)
         {
            ObjectUtils.disposeObject(this._pdescriptTxt1);
         }
         this._pdescriptTxt1 = null;
         if(this._pdescriptTxt2)
         {
            ObjectUtils.disposeObject(this._pdescriptTxt2);
         }
         this._pdescriptTxt2 = null;
         if(this._pdescriptTxt3)
         {
            ObjectUtils.disposeObject(this._pdescriptTxt3);
         }
         this._pdescriptTxt3 = null;
         if(this._pZbdescriptTxt)
         {
            ObjectUtils.disposeObject(this._pZbdescriptTxt);
         }
         this._pZbdescriptTxt = null;
         if(this._pZbdescriptTxt1)
         {
            ObjectUtils.disposeObject(this._pZbdescriptTxt1);
         }
         this._pZbdescriptTxt1 = null;
         if(this._pZbZhidescriptTxt1)
         {
            ObjectUtils.disposeObject(this._pZbZhidescriptTxt1);
         }
         this._pZbdescriptTxt1 = null;
         if(this._pZbZhidescriptTxt)
         {
            ObjectUtils.disposeObject(this._pZbZhidescriptTxt);
         }
         this._pZbZhidescriptTxt = null;
      }
   }
}

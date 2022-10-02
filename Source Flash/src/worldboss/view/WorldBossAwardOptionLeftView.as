package worldboss.view
{
	import com.pickgliss.loader.BaseLoader;
	import com.pickgliss.loader.BitmapLoader;
	import com.pickgliss.loader.LoaderEvent;
	import com.pickgliss.loader.LoaderManager;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.core.Disposeable;
	import com.pickgliss.ui.image.Scale9CornerImage;
	import com.pickgliss.ui.text.GradientText;
	import com.pickgliss.utils.ObjectUtils;
	import ddt.manager.PathManager;
	import ddt.utils.PositionUtils;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import worldboss.WorldBossManager;
   
   public class WorldBossAwardOptionLeftView extends Sprite implements Disposeable
   {
	   private var _titleBack:DisplayObject;
	   
	   private var _titleField:GradientText;
	   
	   private var _bg:Scale9CornerImage;
	   
	   private var _previewLoader:BitmapLoader;
	   
	   private var _previewMap:Bitmap;
	   
	   public function WorldBossAwardOptionLeftView()
	   {
		   super();
		   this.initView();
	   }
	   
	   private function initView() : void
	   {
		   this._bg = ComponentFactory.Instance.creatComponentByStylename("littleGame.leftViewBg");
		   addChild(this._bg);
		   this._titleBack = ComponentFactory.Instance.creatBitmap("asset.littleGame.leftTitle");
		   addChild(this._titleBack);
		   this._titleField = ComponentFactory.Instance.creatComponentByStylename("littleGame.HallTitleField");
		   this._titleField.text = "Long Thần Chiến";
		   addChild(this._titleField);
		   this._previewLoader = LoaderManager.Instance.creatLoader(WorldBossManager.Instance.getWorldbossResource() + "/preview/previewmap.png" ,BaseLoader.BITMAP_LOADER);
		   this._previewLoader.addEventListener(LoaderEvent.COMPLETE,this.__previewMapComplete);
		   LoaderManager.Instance.startLoad(this._previewLoader);
	   }
	   
	   private function __previewMapComplete(evt:LoaderEvent) : void
	   {
		   if(evt.loader.isSuccess)
		   {
			   evt.loader.removeEventListener(LoaderEvent.COMPLETE,this.__previewMapComplete);
			   ObjectUtils.disposeObject(this._previewMap);
			   this._previewMap = null;
			   this._previewMap = evt.loader.content as Bitmap;
			   addChild(this._previewMap);
			   PositionUtils.setPos(this._previewMap,"littleGame.previewMap.pos");
		   }
	   }
	   
	   public function dispose() : void
	   {
		   if(this._previewLoader)
		   {
			   this._previewLoader.removeEventListener(LoaderEvent.COMPLETE,this.__previewMapComplete);
		   }
		   this._previewLoader = null;
		   ObjectUtils.disposeObject(this._bg);
		   this._bg = null;
		   ObjectUtils.disposeObject(this._titleField);
		   this._titleField = null;
		   ObjectUtils.disposeObject(this._titleBack);
		   this._titleBack = null;
		   ObjectUtils.disposeObject(this._previewMap);
		   this._previewMap = null;
	   }
   }
}

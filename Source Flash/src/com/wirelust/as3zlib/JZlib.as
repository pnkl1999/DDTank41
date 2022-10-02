package com.wirelust.as3zlib
{
   public final class JZlib
   {
      
      public static var Z_NO_COMPRESSION:int = 0;
      
      public static var Z_BEST_SPEED:int = 1;
      
      public static var Z_BEST_COMPRESSION:int = 9;
      
      public static var Z_DEFAULT_COMPRESSION:int = -1;
      
      public static var Z_FILTERED:int = 1;
      
      public static var Z_HUFFMAN_ONLY:int = 2;
      
      public static var Z_DEFAULT_STRATEGY:int = 0;
      
      public static var Z_NO_FLUSH:int = 0;
      
      public static var Z_PARTIAL_FLUSH:int = 1;
      
      public static var Z_SYNC_FLUSH:int = 2;
      
      public static var Z_FULL_FLUSH:int = 3;
      
      public static var Z_FINISH:int = 4;
      
      public static var Z_OK:int = 0;
      
      public static var Z_STREAM_END:int = 1;
      
      public static var Z_NEED_DICT:int = 2;
      
      public static var Z_ERRNO:int = -1;
      
      public static var Z_STREAM_ERROR:int = -2;
      
      public static var Z_DATA_ERROR:int = -3;
      
      public static var Z_MEM_ERROR:int = -4;
      
      public static var Z_BUF_ERROR:int = -5;
      
      public static var Z_VERSION_ERROR:int = -6;
       
      
      public var version:String = "1.0.2";
      
      public function JZlib()
      {
         super();
      }
      
      public static function get version() : String
      {
         return version;
      }
   }
}

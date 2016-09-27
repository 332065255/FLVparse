package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	/**
	 *flv解码 
	 * @author gaoyiyi
	 * 
	 */	
	public class flvParse extends Sprite
	{
		private var load:URLLoader;
		private var index:int;
		private var sum:int;
		private var body_sum:int;
		private var label_sum:int;
		private var _str:String;
		private var result:ByteArray;
		private var filere:FileReference;
		public function flvParse()
		{
			filere=new FileReference();
			load=new URLLoader();
			load.dataFormat=URLLoaderDataFormat.BINARY;
			load.load(new URLRequest("2.flv"));
			load.addEventListener(Event.COMPLETE,lis);
			this.stage.addEventListener(MouseEvent.CLICK,lis2);
		}
		private function lis2(e:Event):void
		{
			filere.save(result,"2.flv");
		}
		private function lis(e:Event):void
		{
			parse(load.data as ByteArray);
		}
		private function parse(by:ByteArray):void
		{
			trace(by.length);
			var byte:ByteArray=by;
			byte.position=13;
			index=13;
//			trace(byte[13].toString(16));
			while(index<byte.length&&index!=-1)
			{
				index=next(byte,index);
			}
		}
		private function saveBy(b2:ByteArray,index:int):void{
			result=new ByteArray();
			b2.position=0;
			b2.readBytes(result,0,index+1);
			trace(result);
		}
		private function next(by:ByteArray,_index:int):int{
			sum=0;
			_str="";
			sum+=1;
			trace("当前标签类型:"+by[_index].toString(16))
			
			/////解码body大小
			_index+=1;
			_str+=(by[_index].toString(16).length==1?"0"+by[_index].toString(16):by[_index].toString(16));
			_index+=1;
			_str+=(by[_index].toString(16).length==1?"0"+by[_index].toString(16):by[_index].toString(16));
			_index+=1;
			_str+=(by[_index].toString(16).length==1?"0"+by[_index].toString(16):by[_index].toString(16));
			body_sum=parseInt(_str,16);
			trace("这个包体数据大小是",body_sum,_str);
			if(by.length<body_sum+_index)
			{
				saveBy(by,_index-4);
				return -1;
			}
			sum+=3;
			/////
			/////解码时间
			_index+=4;
			sum+=4;
			/////
			////解码 stream id
			_index+=3;
			sum+=3;
			/////
			/////解码body
			_index+=body_sum;
			sum+=body_sum;
			//////
			////解码这块标签的大小
			_str="";
			_index+=1;
			_str+=(by[_index].toString(16).length==1?"0"+by[_index].toString(16):by[_index].toString(16));
			_index+=1;
			_str+=(by[_index].toString(16).length==1?"0"+by[_index].toString(16):by[_index].toString(16));
			_index+=1;
			_str+=(by[_index].toString(16).length==1?"0"+by[_index].toString(16):by[_index].toString(16));
			_index+=1;
			_str+=(by[_index].toString(16).length==1?"0"+by[_index].toString(16):by[_index].toString(16));
			label_sum=parseInt(_str,16);
			_index+=1;
			trace("上个包体的总大小是:"+label_sum)
			if((label_sum-body_sum)!=11)
			{
				
				trace("出问题了 位置",_index,_str);
				trace("这段代码为",by[_index].toString(16),by[_index+1].toString(16),by[_index+2].toString(16),by[_index+3].toString(16),by[_index+4].toString(16))
				return -1;
			}
			trace("没出问题,位置",_index,_str)
			return _index;
		}
	}
}
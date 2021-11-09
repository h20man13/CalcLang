import java.io.{Reader, InputStream, InputStreamReader}

import java.io.InputStream
import java.io.InputStreamReader
import java.io.Reader
import java.io.IOException

class Source(var reader: Reader, var past: Int, var current: Int, var next: Int, var position: Int) {

    def this(input: Reader) = {
      this(input, -1, -1, input.read(), 0)
      if(hasNext()) advance()
    }

    def advance(): Unit = {
      if(!empty() || hasNext()){
        position = position + 1
	      past = current
	      current = next
		    next = reader.read()
	    }
    }

    def advance(times: Int): Unit = {
	    for(i <- 0 to times){
	      advance()
	    }
    }
    
    def getPast(): Char = past.toChar

    def getCurrent(): Char = current.toChar

    def getNext(): Char = next.toChar

    def hasNext(): Boolean = next != -1

    def empty(): Boolean = current == -1

    def close(): Unit = reader.close()

    def getPosition(): Position = new Position(position)
}
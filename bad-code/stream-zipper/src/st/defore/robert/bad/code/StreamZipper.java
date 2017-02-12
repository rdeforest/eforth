package st.defore.robert.bad.code;

import java.io.IOException;
import java.io.InputStream;
import java.util.*;
import java.util.function.*;
import java.util.stream.*;

/**
 */
public class StreamZipper<A, B> {
    private Stream<A> a;
    private Stream<B> b;

    public StreamZipper(Stream<A> a, Stream<B> b) {
        this.a = a;
        this.b = b;
    }

    public Stream stream() {
        Stream.Builder<AbstractMap.Entry<A, B>> builder = Stream.builder();
        Iterator<B> b = this.b.iterator();

        return a.map((A a) ->
            new AbstractMap.SimpleEntry<A, B>(a, b.next())
        );
    }
}


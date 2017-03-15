package st.defore.robert.bad.code;

import java.util.AbstractMap;
import java.util.Iterator;
import java.util.Map;
import java.util.stream.Stream;

public class StreamZipperTest {
    private static String combine(AbstractMap.Entry<String, Integer> entry) {
        String a = entry.getKey();
        Integer b = entry.getValue();

        return a + ": " + b.toString();

    }
    public static void main(String[] argv) {
        Stream.Builder<String> a = Stream.builder();
        Stream.Builder<Integer> b = Stream.builder();

        a.add("one"); a.add("two"); a.add("three");
        b.add(1);     b.add(2);     b.add(3);

        StreamZipper<String, Integer> testZipper =
                new StreamZipper<String, Integer>(
                        a.build(), b.build());

        Iterator iterator =
            testZipper.stream()
                    .map((entry) -> combine((AbstractMap.Entry<String, Integer>) entry))
                    .iterator();

        assert(iterator.next().equals("one: 1"));
        assert(iterator.next().equals("two: 2"));
        assert(iterator.next().equals("three: 3"));
        System.out.println("It works!");
    }
}

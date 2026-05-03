#include <pcap.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <time.h>

void packet_handler(u_char *args, const struct pcap_pkthdr *header, const u_char *packet) {
    struct ip *ip_header = (struct ip*)(packet + 14); 
    
    if (ip_header->ip_p == IPPROTO_TCP) {
        struct tcphdr *tcp_header = (struct tcphdr*)(packet + 14 + ip_header->ip_hl * 4);
        
        // Detect NULL Scan
        if (tcp_header->th_flags == 0x00) {
            printf("{\"alert\": \"NULL Scan Detected\", \"src_ip\": \"%s\", \"dst_port\": %d, \"timestamp\": %ld}\n", 
                   inet_ntoa(ip_header->ip_src), ntohs(tcp_header->th_dport), header->ts.tv_sec);
            fflush(stdout); 
        }
        
        // Detect Xmas Scan
        if (tcp_header->th_flags == (TH_FIN | TH_PUSH | TH_URG)) {
            printf("{\"alert\": \"Xmas Scan Detected\", \"src_ip\": \"%s\", \"dst_port\": %d, \"timestamp\": %ld}\n", 
                   inet_ntoa(ip_header->ip_src), ntohs(tcp_header->th_dport), header->ts.tv_sec);
            fflush(stdout);
        }
    }
}

int main(int argc, char *argv[]) {
    pcap_t *handle;
    char errbuf[PCAP_ERRBUF_SIZE];
    
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <interface|file.pcap>\n", argv[0]);
        return 1;
    }

    if (strstr(argv[1], ".pcap") != NULL) {
        handle = pcap_open_offline(argv[1], errbuf);
    } else {
        handle = pcap_open_live(argv[1], BUFSIZ, 1, 1000, errbuf);
    }

    if (handle == NULL) {
        fprintf(stderr, "Error opening %s: %s\n", argv[1], errbuf);
        return 2;
    }

    pcap_loop(handle, 0, packet_handler, NULL);
    pcap_close(handle);
    return 0;
}
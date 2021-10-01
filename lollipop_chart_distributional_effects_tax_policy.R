library(ggthemr)
library(ggrepel)

# Loading Data (from Joint Committee on Taxation)
df <- data.frame(z = c(-2.7, -2.4, 5.6, 8.6, 11.1, 14.1, 16.8, 20.1, 25.9, 31.4, 37.2), 
                 y = c(3.2, -0.4, 5.7, 8.6, 11.1, 14.0, 16.7, 19.9, 25.5, 30.5, 31.7),
                 x = c("<$10K", "$10K-$20K", "$20K-$30K", "$30K-$40K", "$40K-$50K",
                       "$50K-$75K", "$75K-$100K", "$100K-$200K", "$200K-$500K",
                       "$500K-$1M", "$1M+"))
df

# Locking order
df$x <- factor(df$x, levels = df$x)

my_pal <- function(range = c(1, 6)) {
  force(range)
  function(x) scales::rescale(x, to = range, from = c(0, 1))
}

ggthemr("flat")

# With legend
df %>%
  ggplot() +
  geom_segment(aes(x=x, xend=x, y=y, yend=z), color="black") +
  geom_text_repel(aes(x=x, y=y, label = paste0(y, "%"), vjust = 0, color = "#003366")) +
  geom_text_repel(aes(x=x, y=z, label = paste0(z, "%"), vjust = 1, color= "#407294")) +
  geom_point(aes(x=x, y=y), color = "#003366", size=3) +
  geom_point(aes(x=x, y=z), color = "#407294", size=3) +
  guides(color = guide_legend(override.aes = list(label = "•", size = 10) ) ) +
  theme(legend.position = "right") +
  xlab("Adjusted Gross Income Category") +
  ylab("Average Tax Rate (%)") +
  scale_colour_manual(name="Legend",
                      values=c("Present Law" ="#003366", Proposal="#407294")) +
  geom_hline(yintercept = 0, size = 0.5, colour="#333333") +
  labs(caption = "Source: Committee for a Responsible Federal Budget using JCT data.") +
  ggtitle("Distributional Effects of Revenue Provisions in House Ways & Means Reconciliation Draft in 2031")

# Without legend
df %>%
  ggplot() +
  geom_segment(aes(x=x, xend=x, y=y, yend=z), color="black") +
  geom_text_repel(aes(x=x, y=y, label = paste0(y, "%")), vjust = 0, color = "#003366") +
  geom_text_repel(aes(x=x, y=z, label = paste0(z, "%")), vjust = 1, color= "#407294") +
  geom_point(aes(x=x, y=y), color = "#003366", size=3) +
  geom_point(aes(x=x, y=z), color = "#407294", size=3) +
  guides(color = guide_legend(override.aes = list(label = "•", size = 10) ) ) +
  theme(legend.position = "right") +
  xlab("Adjusted Gross Income Category") +
  ylab("Average Tax Rate (%)") +
  scale_colour_manual(name="Legend",
                      values=c("Present Law" ="#003366", Proposal="#407294")) +
  geom_hline(yintercept = 0, size = 0.5, colour="#333333") +
  labs(caption = "Source: Committee for a Responsible Federal Budget using JCT data.") +
  ggtitle("Distributional Effects of Revenue Provisions in House Ways & Means Reconciliation Draft in 2031")

